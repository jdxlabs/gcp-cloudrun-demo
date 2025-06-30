
resource "google_cloud_run_v2_service" "default" {
  name     = "fastapi-service"
  location = var.region

  template {
    containers {
      image = "gcr.io/${var.project_id}/fastapi-app"
      ports {
        container_port = 8080
      }
    }
  }
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"
}

resource "google_project_service" "artifact_registry_api" {
  service = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "fastapi-repo"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "default" {
  name        = "fastapi-trigger"
  location    = var.region
  description = "Trigger for fastapi-app"

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = ".*"
    }
  }

  build {
    steps {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${var.project_id}/fastapi-app:latest", "."]
    }
    steps {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "gcr.io/${var.project_id}/fastapi-app:latest"]
    }
  }
}
