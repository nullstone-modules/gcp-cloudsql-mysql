resource "google_compute_global_address" "private_ip" {
  name          = "${local.resource_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = local.vpc_id
}

resource "google_service_networking_connection" "this" {
  network                 = local.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip.name]

  depends_on = [google_project_service.service_networking]
}
