data "google_client_config" "this" {}
data "google_project" "this" {
  project_id = data.google_client_config.this.project
}

locals {
  region     = data.google_client_config.this.region
  project_id = data.google_project.this.project_id
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

// Required for the Private Service Connect endpoint (forwarding rule + reserved IP).
resource "google_project_service" "compute" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

// Required to register the PSC endpoint in the network's internal DNS zone.
resource "google_project_service" "dns" {
  service                    = "dns.googleapis.com"
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
