output "db_instance_name" {
  value       = google_sql_database_instance.this.name
  description = "string ||| Name of the MySQL instance"
}

output "db_master_secret_name" {
  value       = google_secret_manager_secret.password.secret_id
  description = "string ||| The name of the secret in Google Secrets Manager containing the password"
}

output "db_endpoint" {
  value       = "${google_sql_database_instance.this.private_ip_address}:${local.db_port}"
  description = "string ||| The endpoint URL to access the MySQL instance."
}

output "db_admin_function_name" {
  value       = module.db_admin.function_name
  description = "string ||| Google Cloud Function name for database admin utility"
}

output "db_admin_function_url" {
  value       = module.db_admin.function_url
  description = "string ||| Google Cloud Function url for database admin utility"
}

output "db_admin_invoker" {
  value       = module.db_admin.invoker
  description = "object({ email: string, private_key: string }) ||| A GCP service account with explicit privilege invoke db admin cloud function."
  sensitive   = true
}

/*
output "db_log_group" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| The name of the Cloudwatch Log Group where postgresql logs are emitted for the DB Instance"
}

output "db_upgrade_log_group" {
  value       = aws_cloudwatch_log_group.upgrade.name
  description = "string ||| The name of the Cloudwatch Log Group where upgrade logs are emitted for the DB Instance"
}
*/
