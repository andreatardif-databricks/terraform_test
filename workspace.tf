variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_admin_user" {}
variable "google_vpc_id" {}
variable "gke_node_subnet" {}
variable "gke_pod_subnet" {}
variable "gke_service_subnet" {}
variable "gke_master_ip_range" {}

# Get full GCP resource paths for Databricks
data "google_compute_network" "this" {
  name    = var.google_vpc_id
  project = var.google_project_name
}

data "google_compute_subnetwork" "this" {
  name    = var.gke_node_subnet
  region  = var.google_region
  project = var.google_project_name
}

resource "databricks_mws_networks" "this" {
  provider     = databricks.accounts
  account_id   = var.databricks_account_id
  network_name = "${var.google_project_name}-nw-${random_string.suffix.result}"
  gcp_network_info {
    network_project_id    = var.google_project_name
    vpc_id                = data.google_compute_network.this.self_link
    subnet_id             = data.google_compute_subnetwork.this.self_link
    subnet_region         = var.google_region
  }
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

  network_id = databricks_mws_networks.this.network_id
}

output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}
