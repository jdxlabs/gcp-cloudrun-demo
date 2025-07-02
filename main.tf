
# Build & push Docker image to Artifact Registry
##

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "flask-repo"
  description   = "Repository for Flask app"
  format        = "DOCKER"

  labels = {
    managed_by = "terraform"
  }
}

resource "null_resource" "build_image" {
  triggers = {
    dockerfile_hash   = filemd5("${path.root}/app/Dockerfile")
    main_py_hash      = filemd5("${path.root}/app/main.py")
    requirements_hash = filemd5("${path.root}/app/requirements.txt")
  }

  provisioner "local-exec" {
    command = <<-EOT
      gcloud builds submit ${path.root}/app \
        --tag ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/flask-app:latest \
        --project ${var.project_id}
    EOT
  }

  depends_on = [
    google_artifact_registry_repository.repo
  ]
}


# Cloud Run Service
##

resource "google_cloud_run_v2_service" "flask_service" {
  name     = var.service_name
  location = var.region

  labels = {
    managed_by = "terraform"
  }

  template {
    labels = {
      managed_by = "terraform"
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/flask-app:latest"

      ports {
        container_port = 8080
      }

      env {
        name  = "NAME"
        value = "Cloud Run"
      }

      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }
  }

  depends_on = [
    null_resource.build_image
  ]
}


# IAM policy to allow public access
##

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.flask_service.name
  location = google_cloud_run_v2_service.flask_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
