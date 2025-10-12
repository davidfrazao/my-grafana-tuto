#!/usr/bin/env bash
set -euo pipefail


mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<SQL
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY '${EXPORTER_PASSWORD}';
ALTER USER 'exporter'@'%' IDENTIFIED BY '${EXPORTER_PASSWORD}';

GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
GRANT SELECT ON performance_schema.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
SQL

# Show verification (printed in container logs during init)
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" -e \
  "SELECT user,host,plugin FROM mysql.user WHERE user='exporter'; SHOW GRANTS FOR 'exporter'@'%';"
