Grafana offers a wide range of **panel types**, each designed to visualize data in a specific way. Below is a categorized list of the **most common and built-in Grafana panel types** (as of Grafana **v11**, 2025):

---

### 🧭 **Core Visualization Panels**

| Category                  | Panel Type                  | Description                                                                        |
| ------------------------- | --------------------------- | ---------------------------------------------------------------------------------- |
| **Time Series & Metrics** | **Time series**             | The most common panel — shows time-based data as lines, bars, or points.           |
|                           | **Stat**                    | Displays a single number (latest value, min, max, etc.) with thresholds and color. |
|                           | **Gauge**                   | Circular or horizontal gauge visualization for a single value.                     |
|                           | **Bar gauge**               | Similar to gauge but uses horizontal/vertical bars.                                |
|                           | **Bar chart**               | Displays multiple series as bars over time or categories.                          |
|                           | **Pie chart / Donut chart** | Visualizes proportions or percentages.                                             |
|                           | **Histogram**               | Displays distribution of values in buckets.                                        |
|                           | **Heatmap**                 | Shows value densities using color gradients (e.g., latency distribution).          |

---

### 📊 **Tabular & Textual Panels**

| Panel Type                       | Description                                                                      |
| -------------------------------- | -------------------------------------------------------------------------------- |
| **Table**                        | Tabular data visualization with sorting, links, and thresholds.                  |
| **Logs**                         | Displays log lines (typically used with Loki).                                   |
| **Trace**                        | Displays distributed tracing data (e.g., from Tempo or Jaeger).                  |
| **Node Graph**                   | Shows relationships (nodes/edges) — great for service maps or dependency graphs. |
| **State timeline**               | Visualizes state changes over time (e.g., status transitions).                   |
| **Annotations / Event timeline** | Timeline of events or alerts.                                                    |
| **Text**                         | Rich text (Markdown/HTML) content — for notes, titles, or custom dashboards.     |
| **News**                         | Static or dynamic text and images (available in newer versions).                 |

---

### ⚙️ **Specialized & Advanced Panels**

| Panel Type                  | Description                                                                  |
| --------------------------- | ---------------------------------------------------------------------------- |
| **Geomap / Worldmap**       | Displays data on a map (geo-coordinates, countries, etc.).                   |
| **Canvas**                  | Custom UI elements with drag-and-drop — can build diagrams or topology maps. |
| **Histogram**               | Shows value distribution across buckets.                                     |
| **Bar chart (new)**         | Replacement for legacy “Graph” panel with categorical axes.                  |
| **Trace view**              | Used for displaying traces from Tempo, Jaeger, or Zipkin.                    |
| **Flame graph**             | Used for profiling data (e.g., from Pyroscope).                              |
| **Node graph**              | For visualizing connected systems and relationships.                         |
| **XY chart (experimental)** | Scatter or custom X/Y visualizations.                                        |
| **Status history**          | Similar to state timeline but focused on categorical statuses.               |

---

### 🧩 **Community / Plugin Panels (optional via Grafana plugins)**

| Plugin Panel                | Description                                           |
| --------------------------- | ----------------------------------------------------- |
| **Boom Table**              | Advanced table visualization with color-coded cells.  |
| **Plotly Panel**            | Interactive charts (3D, scatter, heatmap, etc.).      |
| **Datatable Panel**         | Enhanced table with pagination and filtering.         |
| **Discrete Panel**          | Color-coded discrete state visualization.             |
| **Polystat Panel**          | Aggregates multiple metrics into a summary tile grid. |
| **Radar Panel**             | Spider/radar chart visualization.                     |
| **Traffic Lights Panel**    | Status light indicators.                              |
| **Worldmap Panel (legacy)** | Older map visualization (replaced by Geomap).         |

---

Would you like me to give you the **exact JSON names** of these panel types (as used in Grafana dashboard JSON files)?
That’s useful if you’re generating dashboards programmatically (e.g., via Terraform, Grafonnet, or provisioning).
