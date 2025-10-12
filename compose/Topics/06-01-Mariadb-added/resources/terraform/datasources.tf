# datasources.tf (fixed for grafana provider v4.x)
locals {
  ds_abs_dir = abspath("${path.module}/${var.datasources_dir}")
  ds_files   = fileset(local.ds_abs_dir, "*.json")
  ds_map     = { for f in local.ds_files : f => jsondecode(file("${local.ds_abs_dir}/${f}")) }

  # Normalize keys coming from JSON files:
  # - allow "access" or "access_mode" in the files
  # - default access_mode to "proxy" if neither provided
  normalized = {
    for k, v in local.ds_map :
    k => merge(v, {
      access_mode = (
        contains(keys(v), "access_mode") ? v.access_mode :
        contains(keys(v), "access")      ? v.access      :
        "proxy"
      )
    })
  }
}

resource "grafana_data_source" "from_files" {
  for_each = local.normalized

  name = lookup(each.value, "name", trimsuffix(each.key, ".json"))
  type = lookup(each.value, "type", "prometheus")
  url  = lookup(each.value, "url",  "http://localhost")

  is_default           = lookup(each.value, "is_default", false)
  access_mode          = lookup(each.value, "access_mode", "proxy")
  basic_auth_enabled   = lookup(each.value, "basic_auth_enabled", false)
  basic_auth_username  = lookup(each.value, "username", null)

  # v4 expects *encoded* strings, not maps
  json_data_encoded          = jsonencode(lookup(each.value, "json_data", {}))
  secure_json_data_encoded   = jsonencode(lookup(each.value, "secure_json_data", {}))
}
