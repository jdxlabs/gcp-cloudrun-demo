
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west9"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "flask-api"
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name"
  type        = string
}
