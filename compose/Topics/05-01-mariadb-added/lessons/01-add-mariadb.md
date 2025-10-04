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

- Run Mariadb container.
- Run phpmyadmin container to configure and manage the database
- Harvet the Mariadb metrics on Prometheus
---
### Mariadb container

We add the mariadb service into the docker compose file: 
- Image: mariadb:11.4
- Mariadb data location: volume
- The entrypoint script: docker-entrypoint-initdb.d
- Create the user and permission

#### *What is /docker-entrypoint-initdb.d/?*
In the official MariaDB (and MySQL) Docker images, there’s a special directory called /docker-entrypoint-initdb.d/.
When the container starts for the first time (when the database is still empty), the entrypoint script will automatically execute all files inside this directory.

---
### mariadb phpmyadmin

We add the phpmyadmin service into the docker compose file: 
- Image: phpmyadmin/phpmyadmin
- Data location: container’s writable layer (Docker’s internal storage (/var/lib/docker))
- Credencial used to connect to the database are ENV VARIABLES

---
### mariadb mysqld_exporter 
We add the mysqld_exporter service into the docker compose file: 
- Image: prom/mysqld-exporter:v0.15.1
- Data location: ${PWD}/compose/data/mysqld-exporter
- Configuration: file (.my.cnf) in the Data location.

---

# start and stop services from docker-compose
Please see, the file named "99-start-and-stop-services.md" in this directory.