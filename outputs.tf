
output "service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.flask_service.uri
}

output "artifact_registry_url" {
  description = "Artifact Registry repository URL"
  value       = google_artifact_registry_repository.repo.name
}
