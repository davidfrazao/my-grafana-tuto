# 1) Create a Grafana token (recommended: Service Account)

* In Grafana: **Administration → Users and access → Service accounts → New service account → New token**. Give it at least **Admin** on the target org/workspace (or the specific alerting/Datasource perms you need). Save the token string. ([Grafana Labs][1])
* Grafana Cloud users can also follow the cloud docs (same idea). ([Grafana Labs][2])

# 2) Wire env vars into your Terraform container

Add these to your `terraform` service (compose) so the provider can read them:

```yaml
environment:
  TF_PLUGIN_CACHE_DIR: /root/.terraform.d/plugin-cache
  TF_INPUT: "1"
  TF_IN_AUTOMATION: "0"
  GRAFANA_URL: "https://<your-grafana-host>"     # e.g. http://grafana:3000 if on the same compose network
  GRAFANA_AUTH: "<service_account_token>"        # just the token string
```

> Tip: keep the token in an `.env` file or Docker secret instead of inline.

# 3) Minimal Terraform provider config

Create `/workspace/providers.tf` inside the container (or on the mounted host folder):

```hcl
terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.0"
    }
  }
}

variable "grafana_url"  { type = string }
variable "grafana_auth" { type = string }

provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_auth  # service account token OR basic "user:pass"
}
```

Terraform will pick up defaults from `GRAFANA_URL` and `GRAFANA_AUTH` if you wire `terraform.tfvars` or use `-var` flags. (Provider fields and auth methods are defined in the official registry docs.) ([Terraform Registry][3])

# 4) Common resources you’ll likely need

### a) A Prometheus (or Mimir-compatible) data source

```hcl
# /workspace/datasource.tf
resource "grafana_data_source" "prom" {
  name = "Prometheus"
  type = "prometheus"
  url  = "http://prometheus:9090"   # or your remote URL

  json_data = jsonencode({
    httpMethod     = "POST"
    manageAlerts   = true
    prometheusType = "Prometheus"
  })
}
```

(Data source schema & options live in the provider docs; exact fields vary by type.) ([Terraform Registry][4])

### b) A folder and an imported dashboard

```hcl
# /workspace/dashboards.tf
resource "grafana_folder" "apps" {
  title = "Apps"
}

resource "grafana_dashboard" "nginx_overview" {
  folder = grafana_folder.apps.id
  config_json = file("${path.module}/dashboards/nginx-overview.json")
}
```

### c) Grafana Alerting: a contact point (e.g., Slack) and a simple policy

```hcl
# /workspace/alerting.tf
resource "grafana_contact_point" "slack" {
  name = "slack-default"
  slack {
    url          = var.slack_webhook
    mention_users = false
  }
}

resource "grafana_notification_policy" "root" {
  contact_point = grafana_contact_point.slack.name
  group_by      = ["..."]   # keep default routing
}
```

(Using Terraform for alerting is the recommended path; create a service account token, then manage contact points/policies/rules as code.) ([Grafana Labs][5])

# 5) Run it from your container

```bash
docker compose up -d terraform
docker exec -it terraform sh
cd /workspace

# If you exported env vars in compose, you can just:
terraform init
terraform apply -auto-approve
```

# 6) Troubleshooting quick hits

* **401/403 auth**: token lacks permissions—ensure it’s a **service account token** with the right role for the org/workspace. ([Grafana Labs][1])
* **Self-hosted over HTTPS with self-signed certs**: consider terminating TLS at a reverse proxy or add a proper CA; avoid disabling verification unless you know the risk.
* **Data source options**: some fields moved over time; always check the resource’s page for your provider version. ([Terraform Registry][4])

If you share your exact Grafana flavor (OSS vs Cloud vs AMG) and which data sources/alerts you want, I’ll tailor the snippets to your stack (including Loki/Tempo/Elasticsearch examples).

[1]: https://grafana.com/docs/grafana/latest/developers/http_api/auth/?utm_source=chatgpt.com "Authentication HTTP API | Grafana documentation"
[2]: https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/terraform/?utm_source=chatgpt.com "Grafana Terraform provider | Grafana Cloud documentation"
[3]: https://registry.terraform.io/providers/grafana/grafana/latest/docs?utm_source=chatgpt.com "Grafana Provider - Terraform Registry"
[4]: https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source.html?utm_source=chatgpt.com "grafana_data_source | Resources | grafana/grafana | Terraform"
[5]: https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/terraform-provisioning/?utm_source=chatgpt.com "Use Terraform to provision alerting resources | Grafana documentation"