# Add Elasticsearch + Kibana + Elasticsearch export to this project


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

## 🧾 Obejctif of the lesson 

### 🧩 Environment Setup & Verification Checklist

* [ ] Start the stack using **Docker Compose** from the **VS Code Docker Extension**.
* [ ] Access the **Prometheus** service — open [http://127.0.0.1:9090](http://127.0.0.1:9090) *(Ctrl + Click)*.
* [ ] Access the **Grafana** service — open [http://127.0.0.1:3000](http://127.0.0.1:3000) *(Ctrl + Click)*.
* [ ] Access the **Elasticsearch** service — open [http://127.0.0.1:8881](http://127.0.0.1:8881) *(Ctrl + Click)*.
* [ ] Access the **Kibana** service — open [http://127.0.0.1:8888](http://127.0.0.1:8888) *(Ctrl + Click)*.
* [ ] Access the **Elasticsearch Exporter Metrics** endpoint — open [http://127.0.0.1:9114/metrics](http://127.0.0.1:9114/metrics) *(Ctrl + Click)*.

### ⚙️ Configuration & Validation Tasks

* [ ] Configure **Prometheus scraping targets** for **Elasticsearch-exporter** to collect metrics. ( use resources script)
  * [ ] configuration in docker-compose file ( Use Vscode extention - container )
  * [ ] configuration external file ( Use Vscode extention - container )
* [ ] View container logs using the **VS Code Docker Extension**.
* [ ] Explore the container file structure and verify file access via the **VS Code Docker Extension**. ( Elasticsearch exporter metrics)
  

---

Would you like me to format this as a **README section** (with brief explanations under each step)?


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


### start and stop services from docker-compose
Please see, the file named "99-start-and-stop-services.md" in this directory.