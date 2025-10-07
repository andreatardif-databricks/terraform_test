# Databricks Workspace Deployment with Cloud Build

This directory contains Terraform configuration and Cloud Build setup to deploy a Databricks workspace in Google Cloud Platform.

## Prerequisites

1. **GCP Project**: You need a GCP project with billing enabled
2. **Databricks Account**: You need a Databricks account with service principal credentials
3. **Network Configuration**: The VPC and subnets referenced in `variables.auto.tfvars` must exist

## Setup Instructions

### 1. Configure Databricks Service Principal

⚠️ **Security Note**: This configuration uses hardcoded Databricks credentials in the Cloud Build file for simplicity. For production environments, consider using Google Secret Manager.

The following credentials are already configured in `cloudbuild.yaml`:
- `databricks_sp_client_id`: `9e52f02e-3246-4b6b-aca2-de6b7b849f4d` <!-- gitleaks:allow -->
- `databricks_sp_client_secret`: `dose078de60adfb9442b5d16caa7d2e85ecb` <!-- gitleaks:allow -->

### 2. Setup Permissions

Run the setup script to configure the necessary permissions:

```bash
# Make the script executable (if not already done)
chmod +x setup-secrets.sh

# Run the setup to configure Cloud Build permissions
./setup-secrets.sh
```

### 3. Deploy Using Cloud Build

You can deploy using Cloud Build in two ways:

#### Option A: Manual Build Submission
```bash
gcloud builds submit --config=cloudbuild.yaml --project=fe-dev-sandbox
```

#### Option B: Cloud Build Trigger
1. Go to Cloud Build Triggers in the GCP Console
2. Create a new trigger
3. Connect it to your repository
4. Set the build configuration file to `terraform_test/cloudbuild.yaml`
5. Configure trigger conditions (e.g., push to main branch)

## Cloud Build Configuration

The `cloudbuild.yaml` file includes:

1. **Authentication Setup**: Automatic GCP authentication and hardcoded Databricks credentials
2. **Terraform Workflow**: Initialize, plan, and apply Terraform configuration
3. **Security**: ⚠️ Credentials are hardcoded in the build file (consider Secret Manager for production)
4. **Logging**: Build logs and outputs are captured
5. **Simplified Setup**: No Secret Manager configuration required

## Required IAM Permissions

The Cloud Build service account needs these permissions:
- `roles/compute.instanceAdmin.v1` (for managing compute resources)
- `roles/compute.networkAdmin` (for network configuration)
- `roles/iam.serviceAccountUser` (for service account impersonation)
- `roles/resourcemanager.projectIamAdmin` (for IAM management)

Note: Secret Manager permissions are not required since credentials are hardcoded.

## Terraform Resources Created

This configuration creates:
1. **Databricks Network Configuration** (`databricks_mws_networks`)
   - Connects to your existing GCP VPC
   - Configures subnets for Databricks clusters
2. **Databricks Workspace** (`databricks_mws_workspaces`)
   - Creates the workspace in your GCP project
   - Configures the workspace location and network

## Outputs

After successful deployment, you'll receive:
- **Databricks Workspace URL**: The URL to access your new Databricks workspace

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Ensure your Databricks service principal has the correct permissions
   - Verify the client ID and client secret are correct in Secret Manager

2. **Network Errors**
   - Verify that the VPC ID and subnet IDs in `variables.auto.tfvars` exist
   - Check that the subnets are in the correct region

3. **Permission Errors**
   - Ensure the Cloud Build service account has all required IAM permissions
   - Check that the Databricks service principal has workspace creation permissions

### Debugging

To debug issues:
1. Check Cloud Build logs in the GCP Console
2. Review Terraform plan output for configuration issues
3. Verify network and IAM configurations in both GCP and Databricks

## Security Considerations

⚠️ **Important Security Notes**:
- Databricks credentials are **hardcoded** in the `cloudbuild.yaml` file
- This approach is suitable for development/testing environments
- **For production environments**, consider:
  - Using Google Secret Manager to store sensitive credentials
  - Implementing proper credential rotation policies
  - Restricting access to the Cloud Build configuration file
- Cloud Build runs in a secure, isolated environment
- All communications use HTTPS/TLS encryption

### Upgrading to Secret Manager (Recommended for Production)

To enhance security, you can upgrade to use Secret Manager:
1. Create secrets in Secret Manager for your Databricks credentials
2. Update the `cloudbuild.yaml` to retrieve secrets instead of using hardcoded values
3. Grant the Cloud Build service account `roles/secretmanager.secretAccessor` permission

## Support

For issues related to:
- **Terraform Configuration**: Check the Databricks Terraform provider documentation
- **Cloud Build**: Review Google Cloud Build documentation
- **Databricks**: Consult Databricks workspace deployment guides
