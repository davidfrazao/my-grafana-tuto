Perfect 👍 Let’s go over the **common Docker Compose workflows** for stopping, restarting, and cleaning up your Elasticsearch + Kibana cluster.

---

# 🔹 1. Stop containers but keep data

```bash
docker-compose stop
```

* Stops all containers in your Compose project.
* **Volumes (like your Elasticsearch data + certs)** are preserved.
* You can restart later with:

  ```bash
  docker-compose start
  ```
* Useful if you want to pause the cluster without losing indices or certs.

---

# 🔹 2. Stop and remove containers (keep data)

```bash
docker-compose down
```

* Stops and removes **containers + networks**, but **keeps volumes** by default.
* Your Elasticsearch data (in `esdata-*` volumes) and certs (in `certs` volume) stay safe.
* Restarting will re-use the volumes:

  ```bash
  docker-compose up -d
  ```

---

# 🔹 3. Stop and remove containers **and volumes** (fresh start)

```bash
docker-compose down -v
```

* Removes containers, networks, **and volumes**.
* **⚠️ This wipes your Elasticsearch cluster data and certs.**
* Next time you run `docker-compose up`, the bootstrap script will re-generate CA, node certs, and you’ll get a clean cluster.

---

# 🔹 4. Restart containers

```bash
docker-compose restart
```

* Stops and starts containers.
* Volumes are untouched.
* Good if you only want to apply config/env changes that don’t affect volumes.

---

# 🔹 5. View logs (after `-d`)

```bash
docker-compose logs -f es01
docker-compose logs -f kibana
```

* `-f` = follow logs live (like `tail -f`).
* Omit the service name (`es01`, `es02`, `es03`, `kibana`) to see all logs at once.

---

# 🔹 Typical workflow for Elasticsearch + Kibana

1. **First run (watch everything):**

   ```bash
   docker-compose up
   ```

   → verify certs/passwords bootstrap correctly, check cluster health.

2. **Switch to background mode:**

   ```bash
   docker-compose up -d
   ```

3. **Check logs if needed:**

   ```bash
   docker-compose logs -f es01
   ```

4. **Pause the cluster but keep data:**

   ```bash
   docker-compose stop
   ```

5. **Full cleanup (dangerous! wipes data):**

   ```bash
   docker-compose down -v
   ```

---

👉 For your case (TLS, certs, passwords):

* Use `docker-compose down` if you just want to restart clean containers **but keep certs and data**.
* Use `docker-compose down -v` only if you want to **re-bootstrap everything** (CA + certs + fresh data).

---


