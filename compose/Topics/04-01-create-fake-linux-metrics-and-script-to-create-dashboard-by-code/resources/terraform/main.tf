###########################################
# Provider
###########################################
provider "grafana" {
  url  = var.grafana_endpoint
  auth = var.grafana_service_account_api_key
}

###########################################
# Folder-aware dashboard deployment
###########################################
locals {
  # Absolute path to the dashboards root
  dashboards_abs_dir = abspath("${path.module}/${var.dashboards_dir}")

  # Match "<folder>/<file>.json" one level deep
  dashboard_files_rel = fileset(local.dashboards_abs_dir, "*/*.json")

  # Folder names are the first path segment
  folders = toset([for rel in local.dashboard_files_rel : split("/", rel)[0]])
}

# Create folders in Grafana
resource "grafana_folder" "folders" {
  for_each = local.folders
  title    = each.key
}

# Create dashboards and place them in the right folder
resource "grafana_dashboard" "deploy" {
  for_each = toset(local.dashboard_files_rel)

  # Absolute path to JSON on disk
  config_json = file("${local.dashboards_abs_dir}/${each.key}")

  # First segment of relative path selects the folder
  folder = grafana_folder.folders[split("/", each.key)[0]].id

  overwrite = true
  message   = "Deployed by Terraform"
}
