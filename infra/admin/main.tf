terraform {
  required_version = ">= 1.9.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    ironic = {
      source = "registry.terraform.io/metal3-community/ironic"
      version = "~> 1.0.0"
    }
  }
}

provider "ironic" {
  auth_strategy = "keystone"
  microversion  = "1.72"
}
