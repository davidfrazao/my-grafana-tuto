# Where: On mariadb 

mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<SQL
CREATE USER 'grafana'@'%' IDENTIFIED BY 'grafanaPass';
GRANT SELECT ON logsim.* TO 'grafana'@'%';
FLUSH PRIVILEGES;
Then use grafana / grafanaPass in the datasource config.
SQL