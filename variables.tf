variable "mysql_version" {
  type        = string
  default     = "8"
  description = "MySQL Engine Version"
}

variable "instance_class" {
  type    = string
  default = "db-f1-micro"
}

variable "allocated_storage" {
  type        = number
  default     = 10
  description = "Allocated storage in GB"
}

variable "backup_retention_count" {
  type        = number
  default     = 5
  description = "The number of backups that are retained before the oldest is deleted"
}

variable "maintenance_window" {
  type = object({
    day : number
    hour : number
  })
  default = {
    day  = 7
    hour = 23
  }
  description = <<EOF
Configuration for maintenance window.
Day of week => 1-7 starts on Monday.
Hour of day => 0-23.
By default, configured for Sunday at 11:00 PM.
EOF
}

variable "high_availability" {
  type        = bool
  default     = false
  description = <<EOF
Enables high availability and failover support on the database instance.
By default, this is disabled. It is recommended to enable this in production environments.
In dev environments, it is best to turn off to save on costs.
EOF
}

variable "enforce_ssl" {
  type        = bool
  default     = false
  description = <<EOF
By default, the postgres cluster will have SSL enabled.
This toggle will require an SSL connection.
This is highly recommended if you have public access enabled.
EOF
}

variable "enable_public_access" {
  type        = bool
  default     = false
  description = <<EOF
By default, the mysql cluster is not accessible to the public.
If you want to access your database, we recommend using a bastion instead.
EOF
}

/*
variable "custom_mysql_params" {
  type        = map(string)
  default     = {}
  description = <<EOF
This is a dictionary of parameters to custom-configure the RDS postgres instance.
For a list of parameters, see https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.Parameters.html
EOF
}
*/
