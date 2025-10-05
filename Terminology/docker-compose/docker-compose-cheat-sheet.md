Perfect 👍 Here’s a **Docker Compose lifecycle cheat sheet** you can keep handy:

---

## 🐳 Docker Compose Cheat Sheet

### 🔹 Start & Run

```bash
# Start all services in foreground (logs show up)
docker-compose up

# Start all services in background
docker-compose up -d

# Start a single service
docker-compose up -d <service_name>
```

---

### 🔹 Stop & Restart

```bash
# Stop services (containers remain)
docker-compose stop

# Restart services
docker-compose restart

# Pause/unpause services
docker-compose pause
docker-compose unpause
```

---

### 🔹 Remove / Clean Up

```bash
# Stop and remove containers + network
docker-compose down

# Remove everything (containers + images + volumes + orphans)
docker-compose down --rmi all --volumes --remove-orphans

# Remove only stopped service containers
docker-compose rm
```

---

### 🔹 Status & Logs

```bash
# Show running services
docker-compose ps

# Show logs for all services
docker-compose logs

# Show logs for one service
docker-compose logs -f <service_name>
```

---

### 🔹 Exec / Run Commands

```bash
# Run a command inside a service container
docker-compose exec <service_name> <command>

# Example: open a shell inside "app" container
docker-compose exec app sh

# Run a one-off container with the service’s config
docker-compose run --rm <service_name> <command>
```

---

⚡ **Pro tip:** Always use `docker-compose down` instead of just `stop` if you want a *clean reset*. Use `--volumes` when you also want to drop data (databases, etc.).

---