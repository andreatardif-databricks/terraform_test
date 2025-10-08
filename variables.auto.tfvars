databricks_account_id = "e11e38c5-a449-47b9-b37f-0fa36c821612"
databricks_account_console_url = "https://accounts.gcp.databricks.com"

databricks_workspace_name = "at_terraform_cloudbuild" 
databricks_admin_user = "andrea.tardif@databricks.com"

google_vpc_id = "hk-network-6e7ehf"
gke_node_subnet = "hk-test-dbx-6e7ehf"
gke_pod_subnet = "pods"
gke_service_subnet = "svc"
gke_master_ip_range = "10.3.0.0/28"

# databricks_google_service_account = "andrea-tardif-sa@fe-dev-sandbox.iam.gserviceaccount.com"
databricks_google_service_account = "andrea-tardif-sa@fe-dev-sandbox.iam.gserviceaccount.com"
google_project_name          = "fe-dev-sandbox" 
google_region                = "us-east1" 
databricks_sp_client_id      = "9e52f02e-3246-4b6b-aca2-de6b7b849f4d" # gitleaks:allow
databricks_sp_client_secret  = "dose078de60adfb9442b5d16caa7d2e85ecb" # gitleaks:allow

# export DATABRICKS_CONFIG_PROFILE=databricks-gcp-account
# gcloud auth login
# gcloud config set auth/impersonate_service_account andrea-tardif-sa@fe-dev-sandbox.iam.gserviceaccount.com
# export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)
