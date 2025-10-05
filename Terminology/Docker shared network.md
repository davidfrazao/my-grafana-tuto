A **Docker shared network** is a **virtual network** created and managed by Docker that allows **multiple containers to communicate with each other** — as if they were on the same local network.

In simple terms:

> A shared network lets containers talk to each other by **name** instead of by IP address, safely isolated from the host and other networks.

---

### 🌐 Key Concepts

| Concept                         | Description                                                                                                                             |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **Bridge Network (default)**    | The default “shared” network type for standalone containers. Containers on the same bridge network can communicate via container names. |
| **User-Defined Bridge Network** | A custom shared network created by the user — provides automatic DNS-based name resolution (recommended).                               |
| **Overlay Network**             | Used in Docker Swarm or multi-host environments — allows containers on different hosts to communicate securely.                         |
| **Host Network**                | Shares the host’s network stack — no isolation (not typically considered “shared” in the same sense).                                   |

---

### 🧱 Example: Shared Bridge Network

```bash
# Create a user-defined network
docker network create my_shared_net

# Run two containers on the same network
docker run -d --name app --network my_shared_net myapp:latest
docker run -d --name db  --network my_shared_net mysql:8
```

Now, inside the `app` container:

```bash
ping db
```

✅ It works — Docker automatically resolves `db` to the container’s internal IP on the same shared network.

---

### 🔒 Why Use a Shared Network?

| Benefit                                  | Explanation                                                                   |
| ---------------------------------------- | ----------------------------------------------------------------------------- |
| **Container-to-container communication** | Containers can reach each other by name (no IP hardcoding).                   |
| **Isolation**                            | Only containers attached to the same Docker network can communicate directly. |
| **Service discovery**                    | Docker provides built-in DNS resolution for container names.                  |
| **Flexibility**                          | You can connect or disconnect containers from a network dynamically.          |

---

### 🧭 Common Commands

```bash
docker network ls                      # List all networks
docker network inspect my_shared_net   # View details of a network
docker network connect my_shared_net my_container  # Attach a container
docker network disconnect my_shared_net my_container  # Detach a container
```

---

Would you like me to add a small **diagram** showing how containers connect through a shared Docker bridge network?
