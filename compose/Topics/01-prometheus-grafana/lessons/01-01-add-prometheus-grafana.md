# Add Prometheus + Grafana to this project


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

* [ ] Verify the file and directory structure.
* [ ] Start the stack using **Docker Compose** from the **VS Code Extension**.
* [ ] Access the **Prometheus** service  — open [http://127.0.0.1:9090](http://127.0.0.1:9090) (Ctrl + Click).
* [ ] Access the  **Grafana** service  — open [http://127.0.0.1:3000](http://127.0.0.1:3000) (Ctrl + Click).
* [ ] Configure **Prometheus scraping targets** for collecting metrics.
* [ ] Configure the **Grafana datasource** (`datasource.yaml`) to connect to Prometheus.
* [ ] View container logs using the **VS Code Docker Extension**.
* [ ] Explore the container file structure and access files via the **VS Code Docker Extension**.
* [ ] Test communication between **Prometheus** and **Grafana** (from Prometheus to Grafana).+
* [ ] Grafana: explore interface - metrics: ( Metrics browser  + command line )
  * [ ] scrape_duration_seconds.
  * [ ] prometheus*
  * [ ] up ?
  * [ ] add scraping to Prometheus 

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

### Test communication btw prometheus to grafana

attach shell to Pronetheus 

```FROM PROMETHEUS
wget -qO- http://grafana:3000
```

### links
### Promtheus
http://127.0.0.1:9090
### Prometheus - metrics
http://127.0.0.1:9090/metrics
### Grafana 
http://127.0.0.1:3000
### Grafana - metrics
http://127.0.0.1:3000/metrics

### start and stop services from docker-compose
Please see, the file named "99-start-and-stop-services.md" in this directory.