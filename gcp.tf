data "google_client_config" "this" {}
data "google_project" "this" {
  project_id = data.google_client_config.this.project
}

locals {
  region = data.google_client_config.this.region
}

resource "google_project_service" "secret_manager" {
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "sqladmin" {
  service                    = "sqladmin.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

// Cloud Run is needed to create a Cloud Function (db-admin)
resource "google_project_service" "run" {
  service                    = "run.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}
// Artifact Registry is needed to create a Cloud Function (db-admin) even though we're not using it
resource "google_project_service" "artifact_registry" {
  service                    = "artifactregistry.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}
