module "db_admin" {
  source  = "api.nullstone.io/nullstone/gcp-mysql-db-admin/gcp"
  version = "~> 0.1.0"

  name   = local.resource_name
  labels = local.labels

  host                      = google_sql_database_instance.this.private_ip_address
  port                      = local.db_port
  username                  = local.root_username
  password                  = random_password.this.result
  vpc_access_connector_name = ""
}
