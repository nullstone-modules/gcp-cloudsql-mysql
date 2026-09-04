data "ns_connection" "notification" {
  name     = "notification"
  contract = "datastore/gcp/notification"
  optional = true
}

locals {
  notification_name = try(data.ns_connection.notification.outputs.notification_name, "")

  instance_name = google_sql_database_instance.this.name
}

# DB Admin Function Error Rate Alert
#
# The db-admin function is a 2nd-gen Cloud Function backed by a Cloud Run service of the same name,
# so its request metrics are reported under the `cloud_run_revision` resource.
locals {
  db_admin_request_count = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${module.db_admin.function_name}\" AND metric.type=\"run.googleapis.com/request_count\""
}

resource "google_monitoring_alert_policy" "db_admin_error_rate" {
  count = local.notification_name == "" ? 0 : 1

  project      = local.project_id
  display_name = "Cloud SQL DB Admin Error Rate High"
  combiner     = "OR"

  conditions {
    display_name = "5xx rate > ${var.admin_thresholds.error_rate}%"

    condition_threshold {
      filter                  = "${local.db_admin_request_count} AND metric.labels.response_code_class=\"5xx\""
      denominator_filter      = local.db_admin_request_count
      duration                = "60s"
      comparison              = "COMPARISON_GT"
      threshold_value         = var.admin_thresholds.error_rate / 100
      evaluation_missing_data = "EVALUATION_MISSING_DATA_INACTIVE"

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }

      denominator_aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = [local.notification_name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "The db-admin function for Cloud SQL instance ${local.instance_name} is returning 5xx responses. Database, user, and grant changes for connected apps will fail until this is resolved. Function logs: resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${module.db_admin.function_name}\""
    mime_type = "text/markdown"
  }
}
