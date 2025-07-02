# gcp-cloudrun-demo

A simple deployment on Cloud Run


## Prerequisites

*   **Terraform:** [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
*   **Google Cloud SDK:** [Install gcloud](https://cloud.google.com/sdk/docs/install)
*   **A Google Cloud Platform (GCP) Project:** [Create a GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)


## Setup Instructions

Active the Google Cloud APIs required for this project:

```bash
gcloud services enable \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  artifactregistry.googleapis.com \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com \
  --project YOUR_PROJECT_ID
```

Verify that the required APIs are enabled

```bash
gcloud services list --enabled --project YOUR_PROJECT_ID
```

## Launch the Demo

This project demonstrates how to deploy a simple Flask application on Google Cloud Run using Terraform. The application is containerized and stored in Google Artifact Registry, with automatic deployment triggered by changes pushed to a GitHub repository.

The project includes a Terraform configuration that sets up the necessary resources in GCP, including:
*   A Cloud Run service to run the Flask application.
*   An Artifact Registry repository to store the Docker image.
*   A Cloud Build trigger to automatically build and deploy the application when changes are pushed to the GitHub repository.

### First, manually create the Cloudbuild trigger in the GCP console:
1. Go to the [Cloud Build Triggers page](https://console.cloud.google.com/cloud-build/triggers).
2. Click on **Create Trigger**.
3. Set the following options:
   - **Name:** `your-github-trigger`
   - **Event:** `Push to a branch`
   - **Source:** `GitHub`
   - **Repository:** Select the repository you created for this project.
   - **Branch:** `main`
   - **Build Configuration:** `Cloud Build configuration file (yaml or json)`
4. Click **Create** to finish setting up the trigger.

### Now you can use Terraform to deploy the application:

```bash
terraform init

terraform plan -var-file=your-env-dev.tfvars
terraform apply -var-file=your-env-dev.tfvars
```

This will create the necessary resources in your GCP project and deploy the Flask application to Cloud Run.

### Access the Application

After the deployment is complete, you can access the Flask application using the URL provided in the output of the `terraform apply` command. The URL will look something like this:

```bash
curl https://your-service-name-abcdefg-uc.a.run.app
```

### Clean Up

To clean up the resources created by this project, you can run the following command:

```bash
terraform destroy -var-file=your-env-dev.tfvars
```


## Notes

- Make sure to replace `YOUR_PROJECT_ID` with your actual GCP project ID in the commands above.
- The `config-dev.tfvars` file contains the configuration variables for your environment. Update it with your project details, such as `project_id`, `region`, `service_name`, `github_username`, and `github_repo_name`.
- The Flask application is a simple API that returns a JSON response with a greeting message. You can modify the application code in the `app.py` file to customize the API behavior.


## Troubleshooting

If you encounter any issues during the deployment or access of the application, check the following:
- Ensure that the Cloud Build trigger is correctly set up and linked to your GitHub repository.
- Verify that the necessary APIs are enabled in your GCP project.
- Check the Cloud Run service logs for any errors or issues during the deployment process.


## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

