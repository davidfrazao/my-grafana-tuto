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

* [ ] copy resources and  delete datasources if needed ( contain datasource configuration )
* [ ] Start the stack using **Docker Compose** from the **VS Code Docker Extension**.
* [ ] Check the docker-compose.03.03.yaml
* [ ] Check the **Terraform** service — is running.
* [ ] Access the **Terraform** service — view logs - Vscode extention Vscode.
* [ ] Attach shell to **Terraform** service and do "curl -fsS http://grafana:3000/api/health && echo" to check Grafana
* [ ] Create a Elasticsearch datasource by code with Terraform.
  * [] 
  * [ ] On Grafana add manually the dashboad : Dashboard -> choose location -> click ( New ) -> import -> add ID -> Select a Prometheus data source.
  * [ ] From the new dashboard: Edit -> Setting -> JSON Model -> copy the content to ./compose/data/terraform/provisioning/dashboards/Group_01/elastic.json
  * [ ] Attach shell to **Terraform** service 

        ```
        terraform plan                 # preview changes
        terraform apply                # apply (interactive approval)
        ```
  * [ ] check dashboard -> [Grafana](http://127.0.0.1:3000)

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

We add the Grafana service into the docker compose file: 
- Image: ocker.elastic.co/elasticsearch/elasticsearch:*
- data location: ./compose/data/elasticsearch/data
---

### Kibana container

We add the Grafana service into the docker compose file: 
- Image: grafana/grafana:*
- data location: Container’s Writable Layer (Internal)
---

### Elasticsearch exporter container

We add the Grafana service into the docker compose file: 
- Image: grafana/grafana:*
- data location: Docker shared directory
- Configuration file: ./compose/data/elasticsearch_exporter/elasticsearch_exporter.yml
---

### Terraform container

We add the Grafana service into the docker compose file: 
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

# start and stop services from docker-compose
Please see, the file named "99-start-and-stop-services.md" in this directory.