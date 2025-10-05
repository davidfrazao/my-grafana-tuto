##v Option 1  — Basic filtering with variables (db, op)

SELECT
  ts, user_host, db_name, op, tbl_name,
  query_time_ms, rows_examined, rows_sent, success, sql_text
FROM mariadb_logs
WHERE $__timeFilter(ts)
  AND db_name IN (${db:sqlstring})
  AND op IN (${op:sqlstring}) 
ORDER BY ts DESC
LIMIT 200;

#######################################################################

## Option 2 — Advanced filtering with variables (db, op)

#( '${db:sqlstring}' = '%' OR db_name IN (${db:csv}) )
# If the variable is All → ${db:sqlstring} becomes % → first test is '% ' = '%' → TRUE → the whole OR is TRUE → filter disabled.
# If the variable is a selection (e.g., appdb) → ${db:sqlstring} is appdb → 'appdb' = '%' → FALSE → second test applies: db_name IN ('appdb') → filter enabled.

# | Variable value    | Left test (`var = '%'`) | Right test (`db_name IN (...)`)    | Result (OR) | Effect          |
# | ----------------- | ----------------------- | ---------------------------------- | ----------- | --------------- |
# | `%` (All)         | TRUE                    | (not evaluated)                    | TRUE        | No filtering    |
# | `appdb`           | FALSE                   | `db_name IN ('appdb')`             | depends     | Filter to appdb |
# | `analytics,appdb` | FALSE                   | `db_name IN ('analytics','appdb')` | depends     | Filter to both  |


SELECT
  ts, user_host, db_name, op, tbl_name,
  query_time_ms, rows_examined, rows_sent, success, sql_text
FROM mariadb_logs
WHERE $__timeFilter(ts)
  AND ( '${db:raw}' = '%' OR db_name IN (${db:sqlstring}) )
  AND ( '${op:raw}' = '%' OR op      IN (${op:sqlstring}) )
ORDER BY ts DESC
LIMIT 200;

#################################################################

