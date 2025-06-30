# gcp-cloudrun-demo

A simple deployment on Cloud Run

## Prerequisites

Before you begin, ensure you have the following installed and configured:

*   **Terraform:** [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
*   **Google Cloud SDK:** [Install gcloud](https://cloud.google.com/sdk/docs/install)
*   **A Google Cloud Platform (GCP) Project:** [Create a GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)

## Setup and Deployment

### 1. Configure Your GCP Project

First, make sure you have a GCP project created and the gcloud CLI is authenticated:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

### 2. Configure Terraform Variables

Edit the `variables.tf` file and provide the following information:

*   `project_id`: Your GCP project ID.
*   `github_owner`: Your GitHub username.
*   `github_repo_name`: The name of the repository you just created.

### 4. Deploy with Terraform

Navigate to the `fastapi_cloudrun_demo` directory in your terminal and run the following commands:

```bash
# Initialize Terraform
terraform init

# Apply the configuration
terraform apply
```

Terraform will provision the following resources:

*   **Cloud Run Service:** A fully managed service to run your containerized FastAPI application.
*   **Artifact Registry Repository:** A private Docker image repository to store your application's container image.
*   **Cloud Build Trigger:** A trigger that automatically builds and deploys your application whenever you push changes to your GitHub repository.

### 5. Access Your Application

Once `terraform apply` is complete, it will output the URL of your service. You can access your running FastAPI application at this URL.

## Continuous Deployment

This project is configured for continuous deployment. Any time you push a change to your GitHub repository, Cloud Build will automatically:

1.  Build a new Docker image from your code.
2.  Push the image to your private Artifact Registry.
3.  Deploy the new image to your Cloud Run service.

This creates a seamless workflow for updating your application.
