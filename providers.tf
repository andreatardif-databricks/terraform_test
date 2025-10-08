variable "databricks_account_id" {}
variable "databricks_google_service_account" {}
variable "google_project_name" {}
variable "google_region" {}
variable "databricks_sp_client_id" {}
variable "databricks_sp_client_secret" {}

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

data "google_client_openid_userinfo" "me" {
}

data "google_client_config" "current" {
}

resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}