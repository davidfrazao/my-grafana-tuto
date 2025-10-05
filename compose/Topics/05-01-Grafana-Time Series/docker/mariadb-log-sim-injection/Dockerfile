FROM alpine:3.20

# Install bash + MariaDB client + utils
RUN apk add --no-cache \
      bash \
      mariadb-client \ 
      coreutils \
      ca-certificates \
      tzdata \
   && update-ca-certificates

WORKDIR /app
COPY mariadb_log_daemon.sh /app/mariadb_log_daemon.sh
RUN chmod +x /app/mariadb_log_daemon.sh

# non-root user
RUN adduser -D -h /app logsim
USER logsim

RUN mkdir -p /app/logs

ENV OUTPUT_LOG=/app/logs/mariadb-sim.log \
    RATE_LPS=20 \
    SLOW_PCT=15 \
    ERROR_PCT=3 \
    BATCH_SIZE=200 \
    MAX_BACKOFF_SEC=20 \
    MYSQL_HOST=mariadb \
    MYSQL_PORT=3306 \
    MYSQL_USER=root \
    MYSQL_PASS=root \
    MYSQL_DB=logsim \
    MYSQL_OPTS="--protocol=TCP --connect-timeout=5"

# Note: mariadb-client provides the `mysql` symlink too; if not,
# you can change your script to call `mariadb` instead of `mysql`.
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=5 \
  CMD mysql ${MYSQL_OPTS} -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u "${MYSQL_USER}" "-p${MYSQL_PASS}" -e "SELECT 1" >/dev/null 2>&1 || exit 1

CMD ["/app/mariadb_log_daemon.sh"]
