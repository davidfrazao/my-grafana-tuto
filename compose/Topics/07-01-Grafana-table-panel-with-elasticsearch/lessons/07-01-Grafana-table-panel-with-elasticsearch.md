# Add mariadb to this project


## Scruture of the topic 

* **`.env` file**
  Stores environment variables. Each topic has its own `.env` file located in the respective directory.

* **`docker-compose-*` files**
  Define the services to be run along with their configurations.

* **`docker/` directory**
  Contains local Docker files referenced by the `docker-compose` configurations.

* **`lessons/` directory**
  Includes installation guides, configuration details, and step-by-step instructions to accomplish the objectives of each lesson.

---

## Obejctif of the lesson 

* [ ] Run docker compose.
* [ ] Test Dashboard with Elasticsearch
---
### Bash script 

We add the Bash script the docker compose file: 
* [ ] On Kibana , validate the index creation + create dataview ( mariadb) 
* [ ] From Grafana - Home - datasource
* [ ] Create new Elasticsearch datasource
  * [ ] name: Elasticsearch-mariadb 
  * [ ] URL: http://elasticsearch:9200
  * [ ] Index name : mariadb*
  * [ ] Create new dashboard -> datasource =  Elasticsearch-mariadb -> panel: table 
    * [ ] check ad-hoc
  * [ ] New panel - Time series - choose ( Query type)



* [ ] Delete this Grafana datasource

### Prometheus container

We add the Prometheus service into the docker compose file: 
- Image: quay.io/prometheus/prometheus:*
- Data location: Docker shared directory
- Configuration file: ./compose/data/prometheus/etc/prometheus.yml

---

### Grafana container

We add the Grafana service into the docker compose file: 
- Image: grafana/grafana:*
- data location: Docker shared directory
- Configuration file: ./compose/data/grafana/etc/provisioning/datasources/datasource.yaml
- 
---

### Elasticsearch container

We add the Elasticsearch service into the docker compose file: 
- Image: ocker.elastic.co/elasticsearch/elasticsearch:*
- data location: ./compose/data/elasticsearch/data
---

### Kibana container

We add the Kibana service into the docker compose file: 
- Image: docker.elastic.co/kibana/kibana:*
- data location: Container’s Writable Layer (Internal)
---

### Elasticsearch exporter container

We add the Elasticsearch exporter service into the docker compose file: 
- Image: quay.io/prometheuscommunity/elasticsearch-exporter:*
- data location: Docker shared directory
- Configuration file: ./compose/data/elasticsearch_exporter/elasticsearch_exporter.yml or docker compose file
---

### Terraform container

We add the Terraform service into the docker compose file: 
- Image: hashicorp/terraform:1.13.3:*
- dockerfile: ./docker/terraform/Dockerfile.terraform
- data location: Docker shared directory
- Configuration file: ./compose/data/terraform + ./compose/data/.terraform-data
---

### Fake-metrics

We add the Fake-metrics service into the docker compose file: 
- dockerfile: ./docker/fake-metrics/Dockerfile

###  mariadb
We add the MaraiDB service into the docker compose file: 
- Image: mariadb:*
- volume: mariadb_data
- Configuration file script : ${PWD}/compose/data/mariadb/initdb/01_create_exporter.sh

### phpmyadmin
We add the Terraform service into the docker compose file: 
- Image: phpmyadmin/phpmyadmin
- data location: Internal docker

###  mysqld_exporter
We add the Terraform service into the docker compose file: 
- Image: prom/mysqld-exporter:* 
- data location: Internal docker
- Configuration file: ${PWD}/compose/data/mysqld-exporter/.my.cnf
  
---

### links
### Promtheus
http://127.0.0.1:9090
### Prometheus - metrics
http://127.0.0.1:9090/metrics
### Grafana 
http://127.0.0.1:3000
### Grafana - metrics
http://127.0.0.1:3000/metrics
### kibana
http://127.0.0.1:8888
### Elastiscearch 
http://127.0.0.1:8881
### Elasticsearch exporter
http://127.0.0.1:9114
### Elasticsearch exporter
http://127.0.0.1:9114/metrics
### fake-metrics
http://127.0.0.1:9500/metrics
### mariadb
http://127.0.0.1:3306
### phpmyadmin
http://127.0.0.1:8080
### mysqld_exporter
http://127.0.0.1:9104



# start and stop services from docker-compose
Please see, the file named "99-start-and-stop-services.md" in this directory.
