resource "google_sql_database_instance" "this" {
  name                = local.resource_name
  database_version    = "MYSQL_${var.mysql_version}_0"
  region              = local.region
  deletion_protection = var.deletion_protection_enabled

  depends_on = [google_project_service.sqladmin]

  settings {
    tier                        = var.instance_class
    activation_policy           = "ALWAYS"
    availability_type           = var.high_availability ? "REGIONAL" : "ZONAL"
    disk_size                   = var.allocated_storage
    disk_autoresize             = true
    disk_type                   = "PD_SSD"
    pricing_plan                = "PER_USE"
    user_labels                 = local.labels
    deletion_protection_enabled = var.deletion_protection_enabled

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
      ssl_mode = var.enforce_ssl ? "ENCRYPTED_ONLY" : "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
      // PSC is mutually exclusive with private services access (private_network) and public access (ipv4_enabled).
      private_network = var.enable_psc ? null : local.vpc_id
      ipv4_enabled    = var.enable_psc ? false : var.enable_public_access

      dynamic "psc_config" {
        for_each = var.enable_psc ? [true] : []

        content {
          psc_enabled               = true
          allowed_consumer_projects = [local.project_id]
        }
      }
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

  // Hostname (no trailing dot) of the Private Service Connect endpoint, registered in the network's internal DNS zone.
  psc_dns_name = "${local.block_name}.${trimsuffix(local.internal_domain_fqdn, ".")}"

  // Endpoint strategy: with PSC, connect via the internal DNS name; otherwise via the private IP.
  db_endpoint_psa = "${google_sql_database_instance.this.private_ip_address}:${local.db_port}"
  db_endpoint_psc = "${local.psc_dns_name}:${local.db_port}"
}

// Warn (rather than fail) when both public access and PSC are requested. They are mutually exclusive;
// PSC takes precedence and public access is forced off.
check "psc_public_access_exclusive" {
  assert {
    condition     = !(var.enable_public_access && var.enable_psc)
    error_message = "enable_public_access and enable_psc are mutually exclusive. PSC takes precedence, so public access will be disabled on this instance."
  }
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
