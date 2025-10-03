#!/usr/bin/env bash
# Continuously simulate MariaDB logs AND ingest structured rows to MariaDB.

set -euo pipefail

### ---------- Config (override via env) ----------
OUTPUT_LOG="${OUTPUT_LOG:-./mariadb-sim.log}"

# generation
RATE_LPS="${RATE_LPS:-20}"
SLOW_PCT="${SLOW_PCT:-15}"
ERROR_PCT="${ERROR_PCT:-3}"

# batching to DB
BATCH_SIZE="${BATCH_SIZE:-200}"
MAX_BACKOFF_SEC="${MAX_BACKOFF_SEC:-20}"

# MariaDB connection
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASS="${MYSQL_PASS:-root}"
MYSQL_DB="${MYSQL_DB:-logsim}"
MYSQL_OPTS="${MYSQL_OPTS:---protocol=TCP --connect-timeout=5}"

# domains of randomization
IFS=$'\n' read -r -d '' -a USERS   <<< "${USERS_LIST:-root@localhost
app@10.0.0.12
report@10.0.0.21
backup@127.0.0.1}" || true

IFS=$'\n' read -r -d '' -a DBS     <<< "${DBS_LIST:-appdb
inventory
analytics
mysql}" || true

IFS=$'\n' read -r -d '' -a OPS     <<< "${OPS_LIST:-SELECT
UPDATE
INSERT
DELETE
ALTER
CREATE
DROP}" || true

IFS=$'\n' read -r -d '' -a TABLES  <<< "${TABLES_LIST:-users
orders
products
events
sessions
payments
logs}" || true
### ----------------------------------------------

# NEW: mysql_cli can take an optional DB name
mysql_cli() {
  # usage: mysql_cli [database] [extra mysql args...]
  local db=""
  if [[ $# -gt 0 && "$1" != -* ]]; then
    db="$1"; shift
  fi
  mysql $MYSQL_OPTS -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" "-p${MYSQL_PASS}" ${db:+"$db"} "$@"
}

# NEW: create DB and table *in that DB*
ensure_schema() {
  # Create DB if missing
  mysql_cli -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DB\`;"

  # Create table inside that DB
  mysql_cli "$MYSQL_DB" -e "
    CREATE TABLE IF NOT EXISTS mariadb_logs (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      ts DATETIME NOT NULL,
      user_host VARCHAR(128),
      db_name VARCHAR(64),
      op VARCHAR(16),
      tbl_name VARCHAR(64),
      query_time_ms INT,
      rows_examined INT,
      rows_sent INT,
      success TINYINT(1),
      sql_text TEXT
    ) ENGINE=InnoDB;"
}

rand_choice() { local arr=("$@"); echo "${arr[$RANDOM % ${#arr[@]}]}"; }
rand_int() { local min="$1" max="$2"; echo $(( RANDOM % (max - min + 1) + min )); }
timestamp() { date "+%Y-%m-%d %H:%M:%S"; }

escape_sql() { printf "%s" "$1" | sed "s/'/''/g"; }

build_query() {
  local db="$1" tbl="$2" op="$3" q
  case "$op" in
    SELECT) q="SELECT * FROM ${db}.${tbl} WHERE id=$(rand_int 1 100000);";;
    UPDATE) q="UPDATE ${db}.${tbl} SET updated_at=NOW() WHERE id=$(rand_int 1 100000);";;
    INSERT) q="INSERT INTO ${db}.${tbl}(id,created_at) VALUES($(rand_int 1 100000),NOW());";;
    DELETE) q="DELETE FROM ${db}.${tbl} WHERE id=$(rand_int 1 100000);";;
    ALTER)  q="ALTER TABLE ${db}.${tbl} ADD COLUMN col_$(rand_int 1 9) INT;";;
    CREATE) q="CREATE TABLE ${db}.${tbl}_$(rand_int 1 9) (id INT PRIMARY KEY);";;
    DROP)   q="DROP TABLE IF EXISTS ${db}.${tbl}_$(rand_int 1 9);";;
  esac
  printf "%s" "$q"
}

log_line() {
  local ts="$1" user="$2" db="$3" qms="$4" rex="$5" rsent="$6" is_slow="$7" sql="$8"
  printf "%s [Query] user=%s db=%s time=%dms rows_examined=%d rows_sent=%d %sSQL: %s\n" \
    "$ts" "$user" "$db" "$qms" "$rex" "$rsent" \
    $([[ "$is_slow" -eq 1 ]] && echo "[SLOW] " || true) \
    "$sql"
}

# global batch buffer
BATCH_ROWS=()
BATCH_COUNT=0

# UPDATED: insert into selected DB
flush_batch() {
  (( BATCH_COUNT == 0 )) && return 0

  local values_sql=""
  local first=1
  for row in "${BATCH_ROWS[@]}"; do
    if (( first )); then values_sql="$row"; first=0; else values_sql="$values_sql,$row"; fi
  done

  local insert_sql="
INSERT INTO mariadb_logs
  (ts, user_host, db_name, op, tbl_name, query_time_ms, rows_examined, rows_sent, success, sql_text)
VALUES $values_sql;"

  local backoff=1
  while true; do
    if mysql_cli "$MYSQL_DB" -e "$insert_sql" >/dev/null 2>&1; then
      BATCH_ROWS=()
      BATCH_COUNT=0
      return 0
    else
      echo "[WARN] Insert batch failed, retrying in ${backoff}s..." >&2
      sleep "$backoff"
      backoff=$(( backoff*2 ))
      (( backoff > MAX_BACKOFF_SEC )) && backoff="$MAX_BACKOFF_SEC"
    fi
  done
}

graceful_exit() {
  echo
  echo "Shutting down, flushing remaining ${BATCH_COUNT} rows..."
  flush_batch || true
  echo "Bye."
  exit 0
}
trap graceful_exit INT TERM

main() {
  ensure_schema
  touch "$OUTPUT_LOG"

  echo "=== MariaDB Log Simulator/Ingester ==="
  echo "Log file: $OUTPUT_LOG"
  echo "Rate: ${RATE_LPS}/sec | Batch: $BATCH_SIZE"
  echo "MariaDB: ${MYSQL_USER}@${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DB}"
  echo "--------------------------------------"

  local lines_per_tick="$RATE_LPS"

  while true; do
    local tick_start_ns; tick_start_ns=$(date +%s%N)

    for ((i=0;i<lines_per_tick;i++)); do
      local ts user db op tbl sql is_slow q_ms rows_examined rows_sent is_err success err_code err_text

      ts="$(timestamp)"
      user="$(rand_choice "${USERS[@]}")"
      db="$(rand_choice "${DBS[@]}")"
      op="$(rand_choice "${OPS[@]}")"
      tbl="$(rand_choice "${TABLES[@]}")"
      sql="$(build_query "$db" "$tbl" "$op")"

      is_slow=$(( RANDOM % 100 < SLOW_PCT ? 1 : 0 ))
      if [[ $is_slow -eq 1 ]]; then
        q_ms=$(rand_int 500 8000)
        rows_examined=$(rand_int 10000 500000)
        rows_sent=$(rand_int 50 2000)
      else
        q_ms=$(rand_int 1 450)
        rows_examined=$(rand_int 1 5000)
        rows_sent=$(rand_int 0 200)
      fi

      is_err=$(( RANDOM % 100 < ERROR_PCT ? 1 : 0 ))
      if [[ $is_err -eq 1 ]]; then
        success=0
        err_code=$(rand_choice "1045" "1064" "1213" "1146")
        case "$err_code" in
          1045) err_text="Access denied for user '${user%%@*}'";;
          1064) err_text="You have an error in your SQL syntax";;
          1213) err_text="Deadlock found when trying to get lock";;
          1146) err_text="Table '${db}.${tbl}' doesn't exist";;
        esac
        printf "%s [ERROR] [%s] %s\n" "$ts" "$err_code" "$err_text" >> "$OUTPUT_LOG"
      else
        success=1
      fi

      log_line "$ts" "$user" "$db" "$q_ms" "$rows_examined" "$rows_sent" "$is_slow" "$sql" >> "$OUTPUT_LOG"

      # batch tuple
      local ts_e user_e db_e op_e tbl_e sql_e
      ts_e="$(escape_sql "$ts")"
      user_e="$(escape_sql "$user")"
      db_e="$(escape_sql "$db")"
      op_e="$(escape_sql "$op")"
      tbl_e="$(escape_sql "$tbl")"
      sql_e="$(escape_sql "$sql")"

      BATCH_ROWS+=("('$ts_e','$user_e','$db_e','$op_e','$tbl_e',$q_ms,$rows_examined,$rows_sent,$success,'$sql_e')")
      ((++BATCH_COUNT))

      if (( BATCH_COUNT >= BATCH_SIZE )); then
        flush_batch
      fi
    done

    local tick_elapsed_ns; tick_elapsed_ns=$(( $(date +%s%N) - tick_start_ns ))
    local tick_elapsed_ms=$(( tick_elapsed_ns / 1000000 ))
    if (( tick_elapsed_ms < 1000 )); then
      local sleep_ms=$(( 1000 - tick_elapsed_ms ))
      sleep "$(awk -v ms="$sleep_ms" 'BEGIN{printf "%.3f", ms/1000}')"
    fi
  done
}

main
