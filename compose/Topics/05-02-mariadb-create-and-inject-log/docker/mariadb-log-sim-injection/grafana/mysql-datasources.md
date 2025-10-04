Grafana supports MySQL/MariaDB natively.

In your docker-compose.yml, Grafana already mounts datasource config. Add a datasource YAML:

compose/data/grafana/etc/provisioning/datasources/mysql.yaml

```
apiVersion: 1

datasources:
  - name: MariaDB Logs
    type: mysql
    access: proxy
    isDefault: false
    url: mariadb:3306
    database: logsim
    user: grafana
    secureJsonData:
      password: grafanaPass   # <- match your root or dedicated logsim user password
    jsonData:
      maxOpenConns: 10
      maxIdleConns: 10
      connMaxLifetime: 14400
```


⚠️ Replace root / changeme with the user you want. Best practice: create a dedicated read-only Grafana user, e.g.:
