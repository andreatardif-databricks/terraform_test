#!/bin/bash

# Setup script for Databricks Terraform Cloud Build deployment
# This script configures the necessary permissions for Cloud Build

set -e

PROJECT_ID="fe-dev-sandbox"

echo "Setting up permissions for Databricks Terraform deployment..."

# Enable required APIs
echo "Enabling required Google Cloud APIs..."
gcloud services enable cloudbuild.googleapis.com --project="$PROJECT_ID"
gcloud services enable compute.googleapis.com --project="$PROJECT_ID"

# Get the Cloud Build service account
CLOUD_BUILD_SA="andrea-tardif-sa@fe-dev-sandbox.iam.gserviceaccount.com"

echo "Cloud Build Service Account: $CLOUD_BUILD_SA"

# Grant additional permissions for Cloud Build to manage resources
echo "Granting additional permissions to Cloud Build service account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$CLOUD_BUILD_SA" \
    --role="roles/compute.instanceAdmin.v1" \
    --condition=None

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$CLOUD_BUILD_SA" \
    --role="roles/compute.networkAdmin" \
    --condition=None

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$CLOUD_BUILD_SA" \
    --role="roles/iam.serviceAccountUser" \
    --condition=None

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$CLOUD_BUILD_SA" \
    --role="roles/resourcemanager.projectIamAdmin" \
    --condition=None

echo "Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Run this script: ./setup-secrets.sh"
echo "2. Create a Cloud Build trigger or submit the build manually"
echo ""
echo "To submit the build manually:"
echo "gcloud builds submit --config=cloudbuild.yaml --project=$PROJECT_ID"
echo ""
echo "Note: Databricks credentials are hardcoded in cloudbuild.yaml"
echo "For production use, consider using Google Secret Manager for better security"
