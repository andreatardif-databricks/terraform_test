variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "google_vpc_id" {}
variable "google_subnet_id" {}
variable "google_region" {}

resource "databricks_mws_networks" "this" {
  provider     = databricks.accounts
  account_id   = var.databricks_account_id
  network_name = "fe-dev-sandbox-nw-d8epy1"
  gcp_network_info {
    network_project_id = var.google_project_name
    vpc_id             = var.google_vpc_id
    subnet_id          = var.google_subnet_id
    subnet_region      = var.google_region
  }
}

resource "databricks_mws_workspaces" "this" {
  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = "${var.databricks_workspace_name}-${random_string.suffix.result}"
  location       = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project_name
    }
  }

  network_id = databricks_mws_networks.this.network_id
}

output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}