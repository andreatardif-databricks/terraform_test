variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_admin_user" {}
variable "google_vpc_id" {}
variable "gke_node_subnet" {}
variable "gke_pod_subnet" {}
variable "gke_service_subnet" {}
variable "gke_master_ip_range" {}
variable "google_shared_vpc_project" {}


resource "random_string" "databricks_suffix" {
  special = false
  upper   = false
  length  = 6
}

resource "databricks_mws_networks" "databricks_network" {
  provider     = databricks.accounts
  account_id   = var.databricks_account_id
  network_name = "${var.google_shared_vpc_project}-nw-${random_string.databricks_suffix.result}"
  gcp_network_info {
    network_project_id    = var.google_shared_vpc_project
    vpc_id                = "projects/${var.google_shared_vpc_project}/global/networks/${var.google_vpc_id}"
    subnet_id             = "projects/${var.google_shared_vpc_project}/regions/${var.google_region}/subnetworks/${var.gke_node_subnet}"
    subnet_region         = var.google_region
  }
}

// create workspace in given VPC
resource "databricks_mws_workspaces" "databricks_workspace" {
  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = var.databricks_workspace_name
  location       = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project_name
    }
  }

  network_id = databricks_mws_networks.databricks_network.network_id
}

output "databricks_host" {
  value = databricks_mws_workspaces.databricks_workspace.workspace_url
}
