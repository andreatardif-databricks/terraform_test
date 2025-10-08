variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_admin_user" {}
variable "google_vpc_id" {}
variable "gke_node_subnet" {}
variable "gke_pod_subnet" {}
variable "gke_service_subnet" {}
variable "gke_master_ip_range" {}

resource "databricks_mws_networks" "this" {
  provider     = databricks.accounts
  account_id   = var.databricks_account_id
  network_name = "fe-dev-sandbox-nw-d8epy1"
  gcp_network_info {
    network_project_id = "fe-dev-sandbox"
    vpc_id             = "projects/fe-dev-sandbox/global/networks/hk-network-6e7ehf"
    subnet_id          = "projects/fe-dev-sandbox/regions/us-east1/subnetworks/hk-test-dbx-6e7ehf"
    subnet_region      = "us-east1"
  }
}

resource "databricks_mws_workspaces" "this" {
  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = var.databricks_workspace_name
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
