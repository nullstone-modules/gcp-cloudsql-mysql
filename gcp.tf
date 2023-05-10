data "google_compute_zones" "available" {}

resource "google_project_service" "secret_manager" {
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "service_networking" {
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

locals {
  project_id      = data.google_compute_zones.available.project
  available_zones = data.google_compute_zones.available.names
}
