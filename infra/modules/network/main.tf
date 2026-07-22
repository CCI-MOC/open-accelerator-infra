terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

data "openstack_networking_network_v2" "external_network" {
  name = var.external_network
}

resource "openstack_networking_network_v2" "this" {
  name           = var.name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "this" {
  name       = var.name
  network_id = openstack_networking_network_v2.this.id
  cidr       = var.cidr
  ip_version = var.ip_version

  dynamic "allocation_pool" {
    for_each = var.allocation_pool != null ? [var.allocation_pool] : []
    content {
      start = allocation_pool.value.start
      end   = allocation_pool.value.end
    }
  }
}

resource "openstack_networking_router_v2" "this" {
  name                = var.name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.this.id
  subnet_id = openstack_networking_subnet_v2.this.id
}
