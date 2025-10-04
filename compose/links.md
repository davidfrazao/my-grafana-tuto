# preparation 

[source](https://techviewleo.com/run-prometheus-and-grafana-using-docker-compose)

# grafana config
get The content for Grafana default configuration

wget https://raw.githubusercontent.com/grafana/grafana/main/conf/defaults.ini -O ./compose/config/grafana/grafana.ini

# Grafana datasource
At this point, Grafana does not show where to get data from. We need to tell it to get from Prometheus. 
Create a file called datasource.yml in the grafana directory.

from ./compose/config/grafana

tee ./datasource.yml<<EOF
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  url: http://localhost:9090 
  isDefault: true
  access: proxy
  editable: true
EOF


# prometheus config
from ./compose/config/prometheus

create prometheus configuration file to tell Prometheus where to take the metrics. Since I don’t have a separate server to monitor, the metrics to be exposed are for the prometheus server itself (localhost:9090)

tee ./prometheus.yml<<EOF
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
alerting:
  alertmanagers:
  - static_configs:
    - targets: []
    scheme: http
    timeout: 10s
    api_version: v1
scrape_configs:
- job_name: prometheus
  honor_timestamps: true
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - localhost:9090
EOF

# run compose 

docker compose -f docker-compose.yaml up
docker compose -f docker-compose.v2.yaml up

# web url
# promtheus
http://127.0.0.1:9090
# grafana 
http://127.0.0.1:3000
# elastic
http://127.0.0.1:8881
# kibana
http://127.0.0.1:8888
# elastic exporter
http://127.0.0.1:9114
# phpadmin
http://127.0.0.1:8080
# mysqld_exporter
http://127.0.0.1:9104

# it 
docker exec -it  prometheus sh

docker exec -it  grafana sh

docker exec -it --user root elasticsearch_exporter sh 