In Grafana, you can import a dashboard **by its ID** directly from [Grafana.com’s dashboard library](https://grafana.com/grafana/dashboards).

Here are the steps:

### 1. From the Grafana UI

1. Log in to Grafana.
2. Go to the left menu → **Dashboards** → **+ Import**.
3. In the “Import via grafana.com” field, enter the **Dashboard ID** (e.g., `1860` for Node Exporter Full).
4. Click **Load**.
5. Select the data source(s) the dashboard should use.
6. Click **Import**.

---

### 2. From JSON file (alternative)

If you’ve already downloaded the JSON from grafana.com or another source:

1. Go to **Dashboards → + Import**.
2. Upload the `.json` file or paste the JSON into the text area.
3. Map the data source(s).
4. Click **Import**.

---

### 3. With Grafana API (automation way)

You can also use the HTTP API to import a dashboard:

```bash
curl -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer <API_KEY>" \
    -d @dashboard.json \
    http://<GRAFANA_HOST>:3000/api/dashboards/db
```

Here `dashboard.json` can be either a downloaded JSON or a JSON generated from Grafana.com.

---

👉 Do you want me to give you an **example with a specific dashboard ID** (like Node Exporter’s `1860`) so you can copy-paste and test it?
