data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
  contract = "network/gcp/vpc"
}

locals {
  vpc_id             = data.ns_connection.network.outputs.vpc_id
  private_subnet_ids = data.ns_connection.network.outputs.private_subnets_ids
  private_cidrs      = data.ns_connection.network.outputs.private_cidrs
}
