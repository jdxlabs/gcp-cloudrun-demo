
# Build & push Docker image to Artifact Registry
##

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "flask-repo"
  description   = "Repository for Flask app"
  format        = "DOCKER"
}


# Cloud Build, to trigger the build of the Docker image
##

resource "google_cloudbuild_trigger" "build_trigger" {
  name        = "flask-app-build"
  description = "Build Flask app Docker image"

  github {
    owner = var.github_username
    name  = var.github_repo_name
    push {
      branch = "^main$"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t",
        "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/flask-app:$COMMIT_SHA",
        "./app"
      ]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/flask-app:$COMMIT_SHA"
      ]
    }

    images = [
      "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/flask-app:$COMMIT_SHA"
    ]
  }

  depends_on = [google_project_service.cloud_build_api]
}


# Cloud Run Service
##

resource "google_cloud_run_v2_service" "flask_service" {
  name     = var.service_name
  location = var.region

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/flask-app:latest"

      ports {
        container_port = 8080
      }

      env {
        name  = "NAME"
        value = "Cloud Run"
      }

      env {
        name  = "PORT"
        value = "8080"
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

  depends_on = [google_project_service.cloud_run_api]
}


# IAM policy to allow public access
##

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.flask_service.name
  location = google_cloud_run_v2_service.flask_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
