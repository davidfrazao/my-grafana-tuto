provider "grafana" {
  url  = var.grafana_endpoint
  auth = var.grafana_service_account_api_key
}
###########################################
# FOLDER-AWARE DASHBOARD DEPLOYMENT (CLEAN)
############################################

# Where your JSON files live on disk
# Example structure:
# provisioning/dashboards/
# ├── Stage/
# │   └── first_dashboard.json
# └── Prod/
#     └── another_dashboard.json
locals {
  dashboards_dir  = "${path.module}/provisioning/dashboards"
  dashboard_files = fileset(local.dashboards_dir, "*/*.json") # e.g. ["Stage/first_dashboard.json", "Prod/another.json"]

  # Unique folder names derived from the rel paths
  folders = toset([for rel in local.dashboard_files : split("/", rel)[0]])
}

# Create the folders in Grafana
resource "grafana_folder" "folders" {
  for_each = local.folders
  title    = each.key
}

# Create dashboards and place them in the right folder
resource "grafana_dashboard" "deploy_dashboard" {
  for_each = toset(local.dashboard_files)

  # Absolute file path to JSON (no double "Stage")
  config_json = file("${local.dashboards_dir}/${each.key}")

  # Folder = first segment of the relative path
  folder = grafana_folder.folders[split("/", each.key)[0]].id

  overwrite = true
  message   = "Deployed by Terraform"
}