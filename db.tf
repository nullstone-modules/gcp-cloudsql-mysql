resource "google_sql_database_instance" "this" {
  name                = local.resource_name
  database_version    = "MYSQL_${var.mysql_version}_0"
  region              = local.region
  deletion_protection = false

  depends_on = [google_project_service.sqladmin]

  settings {
    tier              = var.instance_class
    activation_policy = "ALWAYS"
    availability_type = var.high_availability ? "REGIONAL" : "ZONAL"
    disk_size         = var.allocated_storage
    disk_autoresize   = true
    disk_type         = "PD_SSD"
    pricing_plan      = "PER_USE"
    user_labels       = local.labels

    backup_configuration {
      enabled                        = true
      start_time                     = "02:00"
      transaction_log_retention_days = var.backup_retention_count
      binary_log_enabled             = true

      backup_retention_settings {
        retention_unit   = "COUNT"
        retained_backups = var.backup_retention_count
      }
    }

    maintenance_window {
      day          = var.maintenance_window.day
      hour         = var.maintenance_window.hour
      update_track = "stable"
    }

    ip_configuration {
      ssl_mode        = var.enforce_ssl ? "ENCRYPTED_ONLY" : "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
      private_network = local.vpc_id
      ipv4_enabled    = var.enable_public_access
    }

    insights_config {
      query_insights_enabled  = true
      record_application_tags = true
      record_client_address   = true
    }
  }
}

locals {
  db_port = 3306
}

/*
choices made:
mysql 8
name: test-mysql
root password: 5qFk9]Lxl6~QO7Y)
region: use-central1
zone availability: single zone
machine type: high memory (2 vCPUs, 8GB memory)
storage type: SSD
storage capacity: 100GB
enable automatic storage increases: yes
connections: private IP
network for private IP: default
Your network "default" requires a private services access connection.
  - enabled
  - allocate IP range: automatically allocated
data protection:
  - automate backups: 2-6AM
  - enable point-in-time recovery: yes
  - enable deletion protection: yes
maintenance:
  - window: any window
  - order of update: any
flags: none set
labels: none added
*/
