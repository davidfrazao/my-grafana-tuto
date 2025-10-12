# Where: On mariadb 
# MariaDB 10.4+
```
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<'SQL'
CREATE USER IF NOT EXISTS 'grafana'@'%' IDENTIFIED BY ${GRAFANA_PASSWORD:-'GrafanaPW'};
ALTER USER 'grafana'@'%' IDENTIFIED BY ${GRAFANA_PASSWORD:-'GrafanaPW'};
GRANT SELECT ON logsim.* TO 'grafana'@'%';
FLUSH PRIVILEGES;
SQL
```

# check the user was created
```
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" -e "SELECT user, host FROM mysql.user WHERE user='grafana';"
```
# Test the new account
```
mariadb -hmariadb -P3306 -ugrafana -pGrafanaPW -D logsim \
  -e "SELECT COUNT(*) FROM mariadb_logs LIMIT 1;"
```

# Point Grafana at it

In your Grafana datasource (UI or provisioning file), use:

Host: mariadb:3306
Database: logsim
User: grafana
Password: GrafanaPW
