# check the row count in the mariadb_logs
# where: On container: mariadb-log-sim-injection

mysql -hmariadb -P3306 -uroot -p"$MYSQL_PASS" -D logsim   -e "SELECT COUNT(*) AS total_rows FROM mariadb_logs;"