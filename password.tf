locals {
  root_username = "root@%"
}

resource "random_password" "this" {
  // Master password length constraints differ for each database engine. For more information, see the available settings when creating each DB instance.
  length  = 16
  special = true

  // The password for the master database user can include any printable ASCII character except /, ", @, or a space.
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  // Valid metadata name: [a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
  app_secret_store_name = "${local.resource_name}-gsm-secrets"
}

resource "google_secret_manager_secret" "password" {
  // Valid secret_id: [[a-zA-Z_0-9]+]
  secret_id = "${local.resource_name}_master"
  labels    = local.tags

  replication {
    automatic = true
  }

  depends_on = [google_project_service.secret_manager]
}

resource "google_secret_manager_secret_version" "app_secret" {
  secret      = google_secret_manager_secret.password.id
  secret_data = jsonencode(tomap({ "username" = local.root_username, "password" = random_password.this.result }))
}
