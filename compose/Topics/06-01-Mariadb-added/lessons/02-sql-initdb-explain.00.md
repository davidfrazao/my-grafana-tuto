
# explanation of the sql scripte executed at the firts exection.

The sql script is located : ${PWD}/compose/data/mariadb/initdb/01_create_exporter.sh:

This is a **here-document** (`<<SQL ... SQL`) that sends SQL commands directly into the `mariadb` client.

---

### 1. Command start

```bash
mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" <<SQL
```

* Runs the `mariadb` client.
* `-u root` → log in as the `root` user.
* `-p"$MARIADB_ROOT_PASSWORD"` → supply the root password from an environment variable.
* `<<SQL ... SQL` → everything between these markers is passed as SQL input.

---

### 2. Create monitoring user

```sql
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY '${EXPORTER_PASSWORD}';
```

* Creates a user named `exporter`.
* `'%'` means the user can connect from **any host**.
* If the user already exists, this won’t fail (`IF NOT EXISTS`).
* Password is set to `${EXPORTER_PASSWORD}` (another environment variable).

---

### 3. Ensure password is updated

```sql
ALTER USER 'exporter'@'%' IDENTIFIED BY '${EXPORTER_PASSWORD}';
```

* Updates the user’s password just in case it already existed.
* Ensures the `exporter` account has the right password.

---

### 4. Grant monitoring privileges

```sql
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
```

* `PROCESS` → allows seeing running threads/queries (`SHOW PROCESSLIST`).
* `REPLICATION CLIENT` → allows checking replication status (`SHOW MASTER STATUS`, `SHOW SLAVE STATUS`).
* `SELECT ON *.*` → read-only access to all databases (but only SELECT).
  👉 These are the typical privileges required by **MariaDB/MySQL exporters** (e.g., Prometheus `mysqld_exporter`).

---

### 5. Grant access to performance_schema

```sql
GRANT SELECT ON performance_schema.* TO 'exporter'@'%';
```

* Gives permission to read metrics/statistics from the **performance_schema** database.161968161968
* This is where MariaDB stores runtime performance and system data.

---

### 6. Apply changes

```sql
FLUSH PRIVILEGES;
```

* Forces MariaDB to reload the user/privilege tables immediately.

---

✅ **Summary**
This script creates (or updates) a **monitoring user `exporter`** with just enough privileges to collect metrics from MariaDB (commonly for Prometheus/MySQL Exporter).

It’s limited to **read-only + process info** so it can’t modify data.

---

Do you want me to also show you the **minimal privileges needed** for `mysqld_exporter` in MariaDB (so you don’t give more than necessary)?
