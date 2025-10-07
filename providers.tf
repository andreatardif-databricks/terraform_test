variable "databricks_account_id" {}
variable "databricks_google_service_account" {}
variable "google_project_name" {}
variable "google_region" {}

variable "databricks_sp_client_id" {}
variable "databricks_sp_client_secret" {}

# impersonate_service_account = var.databricks_google_service_account


terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
  }
}

provider "google" {
  project = var.google_project_name
  region  = var.google_region
}

// initialize provider in "accounts" mode to provision new workspace

provider "databricks" {
  alias         = "accounts"
  host          = "https://accounts.gcp.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.databricks_sp_client_id
  client_secret = var.databricks_sp_client_secret
}

# Workspace provider - uncomment after workspace is created if you need workspace-level operations
# provider "databricks" {
#   host          = databricks_mws_workspaces.databricks_workspace.workspace_url
#   client_id     = var.databricks_sp_client_id
#   client_secret = var.databricks_sp_client_secret
# }