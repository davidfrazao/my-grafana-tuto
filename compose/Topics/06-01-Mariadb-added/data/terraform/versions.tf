// Update versions as appropriate for time of reading
terraform {
  required_version = ">= 1.1.0"
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "4.10.0"
    }
  }
}