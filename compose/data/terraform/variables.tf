variable "grafana_dashboard_folder_name" {
  description = "Folder name created on grafana istance"
  type        = string
  default     = "stage"
}

variable "grafana_dashboard_folder_Stage" {
  description = "Folder name created on grafana istance"
  type        = string
  default     = "Stage"
}

variable "grafana_dashboard_folder_Observability" {
  description = "Folder name created on grafana istance"
  type        = string
  default     = "Observability"
}

variable "dashboard_file_path" {
  description = "Grafana dashboard file  local path"
  type        = string
  default     = "/workspace/provisioning/dashboards/"
}

variable "grafana_endpoint" {
  type        = string
  description = "Define Endpoint of Grafana"
  default     = "http://grafana:3000"
}


variable "grafana_service_account_api_key" {
  type        = string
  description = "Define API key to conect Grafana instance"
  default     = "glsa_OXw0LAMkij6wIY7iBiv2PEM8Z4o6XNQh_3943ae9f"
}