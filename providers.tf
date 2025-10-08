variable "databricks_account_id" {}
variable "databricks_google_service_account" {}
variable "google_project_name" {}
variable "google_region" {}

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
  project                    = "fe-dev-sandbox"
  impersonate_service_account = "andrea-tardif-sa@fe-dev-sandbox.iam.gserviceaccount.com"
}

// initialize provider in "accounts" mode to provision new workspace

provider "databricks" {
  alias                  = "accounts"
  host                   = "https://accounts.gcp.databricks.com"
  account_id             = var.databricks_account_id
  google_service_account = "andrea-tardif-sa@fe-dev-sandbox.iam.gserviceaccount.com"
}

resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}