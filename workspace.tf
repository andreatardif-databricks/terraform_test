variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_admin_user" {}
variable "google_vpc_id" {}
variable "gke_node_subnet" {}
variable "gke_pod_subnet" {}
variable "gke_service_subnet" {}
variable "gke_master_ip_range" {}
variable "google_shared_vpc_project" {}

# We don't need random suffix or data sources since using existing network
# resource "random_string" "databricks_suffix" removed
# data sources removed since not creating network

# Use existing Databricks network instead of creating new one
# Service principal lacks permission to create networks, but existing ones work
locals {
  # Use first available existing network for this VPC
  existing_network_id = "6a1a267a-a1a3-4a4f-9de7-a1be326cc2f6"
}

// create workspace in given VPC
resource "databricks_mws_workspaces" "databricks_workspace" {
  provider       = databricks.accounts
  # account_id     = var.databricks_account_id
  workspace_name = var.databricks_workspace_name
  location       = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project_name
    }
  }

  network_id = local.existing_network_id
}

output "databricks_host" {
  value = databricks_mws_workspaces.databricks_workspace.workspace_url
}
