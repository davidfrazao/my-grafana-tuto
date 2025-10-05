# 
variable "dashboards_dir" {
  description = "Relative path (from this module) to the dashboards root"
  type        = string
  default     = "provisioning/dashboards"
}

variable "grafana_endpoint" {
  description = "Grafana base URL"
  type        = string
  default     = "http://grafana:3000"

  validation {
    condition     = can(regex("^https?://", var.grafana_endpoint))
    error_message = "grafana_endpoint must start with http:// or https://"
  }
}

variable "grafana_service_account_api_key" {
  description = "Grafana service account token (use env: TF_VAR_grafana_service_account_api_key)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.grafana_service_account_api_key) > 0
    error_message = "Provide a non-empty Grafana token via environment or tfvars."
  }
}

# Directory INSIDE the container (mapped from your host path)
variable "datasources_dir" {
  description = "Absolute or module-relative path to datasource JSON files"
  type        = string
  # If you prefer an absolute path, you can also set: "/workspace/provisioning/datasource"
  default     = "provisioning/datasources"
}
