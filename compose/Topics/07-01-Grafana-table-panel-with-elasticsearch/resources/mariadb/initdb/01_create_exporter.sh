#!/usr/bin/env bash
set -euo pipefail

# Create user
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<SQL
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY '${EXPORTER_PASSWORD}';
ALTER USER 'exporter'@'%' IDENTIFIED BY '${EXPORTER_PASSWORD}';
SQL

# Permission user
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<SQL
GRANT REPLICA MONITOR ON *.* TO 'exporter'@'%';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
GRANT SELECT ON performance_schema.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
SQL

# Log in via socket from localhost ( not best pratice
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<SQL
-- Admin over TCP (use a strong password!)
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
SQL

# Show verification (printed in container logs during init)
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" -e \
  "SELECT user,host,plugin FROM mysql.user WHERE user='exporter'; SHOW GRANTS FOR 'exporter'@'%';"

