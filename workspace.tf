variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_admin_user" {}
variable "google_vpc_id" {}
variable "gke_node_subnet" {}
variable "gke_pod_subnet" {}
variable "gke_service_subnet" {}
variable "gke_master_ip_range" {}

# Use existing Databricks network (service principal lacks network creation permission)
locals {
  existing_network_id = "6a1a267a-a1a3-4a4f-9de7-a1be326cc2f6"
}

resource "databricks_mws_workspaces" "this" {
  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = "tf-demo-test-${random_string.suffix.result}"
  location       = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project_name
    }
  }

  network_id = local.existing_network_id
}

output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}
