variable "databricks_account_id" {}
variable "databricks_google_service_account" {}
variable "google_project_name" {}

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
  project                     = var.google_project_name
  impersonate_service_account = var.databricks_google_service_account
}

provider "databricks" {
  alias                  = "accounts"
  host                   = "https://accounts.gcp.databricks.com"
  account_id             = var.databricks_account_id
  google_service_account = var.databricks_google_service_account
}

resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}