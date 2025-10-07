variable "databricks_google_service_account" {}
variable "google_project_name" {}
variable "google_region" {}

# Databricks authentication via environment variables only:
# DATABRICKS_HOST, DATABRICKS_ACCOUNT_ID, DATABRICKS_CLIENT_ID, DATABRICKS_CLIENT_SECRET

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
  alias = "accounts"
  # Configuration via environment variables:
  # DATABRICKS_HOST, DATABRICKS_ACCOUNT_ID, DATABRICKS_CLIENT_ID, DATABRICKS_CLIENT_SECRET
}

# Workspace provider - uncomment after workspace is created if you need workspace-level operations
# provider "databricks" {
#   host          = databricks_mws_workspaces.databricks_workspace.workspace_url
#   client_id     = var.databricks_sp_client_id
#   client_secret = var.databricks_sp_client_secret
# }