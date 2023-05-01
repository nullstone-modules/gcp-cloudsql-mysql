terraform {
  required_providers {
    google = {
      version = "4.63.1"
    }
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  tags          = { for k, v in data.ns_workspace.this.tags : lower(k) => v }
  block_name    = data.ns_workspace.this.block_name
  resource_name = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
  labels = {
    "nullstone.io/stack"      = data.ns_workspace.this.stack_name
    "nullstone.io/block-ref"  = data.ns_workspace.this.block_ref
    "nullstone.io/block-name" = data.ns_workspace.this.block_name
    "nullstone.io/env"        = data.ns_workspace.this.env_name
  }
}
