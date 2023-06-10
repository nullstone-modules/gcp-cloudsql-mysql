data "ns_connection" "network" {
  name     = "network"
  contract = "network/gcp/vpc"
}

locals {
  vpc_id               = data.ns_connection.network.outputs.vpc_id
  vpc_access_connector = data.ns_connection.network.outputs.vpc_access_connector
}
