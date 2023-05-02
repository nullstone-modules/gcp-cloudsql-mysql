output "db_instance_name" {
  value       = google_sql_database_instance.this.name
  description = "string ||| Name of the MySQL instance"
}

output "db_instance_id" {
  value       = google_sql_database_instance.this.id
  description = "string ||| ID of the MySQL instance"
}

output "db_master_secret_name" {
  value       = google_secret_manager_secret.password.secret_id
  description = "string ||| The name of the secret in Google Secrets Manager containing the password"
}

output "db_endpoint" {
  value       = google_sql_database_instance.this.self_link
  description = "string ||| The endpoint URL to access the MySQL instance."
}

/*
output "db_security_group_id" {
  value       = aws_security_group.this.id
  description = "string ||| The ID of the security group attached to the Postgres instance."
}

output "db_admin_function_name" {
  value       = module.db_admin.function_name
  description = "string ||| AWS Lambda Function name for database admin utility"
}

output "db_admin_function_url" {
  value       = module.db_admin.function_url
  description = "string ||| AWS Lambda Function url for database admin utility"
}

output "db_admin_invoker" {
  value       = module.db_admin.invoker
  description = "object({ name: string, access_key: string, secret_key: string }) ||| IAM User with explicit permissions to invoke db admin lambda function."
  sensitive   = true
}

output "db_log_group" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| The name of the Cloudwatch Log Group where postgresql logs are emitted for the DB Instance"
}

output "db_upgrade_log_group" {
  value       = aws_cloudwatch_log_group.upgrade.name
  description = "string ||| The name of the Cloudwatch Log Group where upgrade logs are emitted for the DB Instance"
}
*/
