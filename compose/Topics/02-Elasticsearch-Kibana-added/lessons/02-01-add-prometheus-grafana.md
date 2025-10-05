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

- Run Prometheus container.
- Run Grafana
- How to: Configure scraping metrics from Prometheus
- How to: Configure datasource - datasource.yaml
# - How to: Configure datasource - manual

### Prometheus container

We add the Prometheus service into the docker compose file: 
- Image: quay.io/prometheus/prometheus:*
- Data location: Docker shared directory
- Configuration file: ./compose/prometheus/etc/prometheus.yml

---
### Grafana container

We add the Grafana service into the docker compose file: 
- Image: grafana/grafana:*
- data location: Docker shared directory
- Configuration file: ./compose/grafana/etc/provisioning/datasources/datasource.yaml
- 
---

# start and stop services from docker-compose
Please see, the file named "99-start-and-stop-services.md" in this directory.