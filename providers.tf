variable "databricks_account_id" {}
variable "databricks_google_service_account" {}
variable "google_project_name" {}
variable "google_region" {}
variable "databricks_sp_client_id" {}
variable "databricks_sp_client_secret" {}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"   # or newer stable you prefer
    }
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
  }
}

# Account-scoped provider (used to create MWS resources)
provider "databricks" {
  alias         = "accounts"
  host          = "https://accounts.gcp.databricks.com"
  account_id    = var.databricks_account_id
  auth_type     = "oauth-m2m"
  client_id     = var.databricks_sp_client_id
  client_secret = var.databricks_sp_client_secret
}

# Workspace-scoped provider (used AFTER the workspace exists)
provider "databricks" {
  alias         = "workspace"
  host          = databricks_mws_workspaces.databricks_workspace.workspace_url
  auth_type     = "oauth-m2m"
  client_id     = var.databricks_sp_client_id
  client_secret = var.databricks_sp_client_secret
}
