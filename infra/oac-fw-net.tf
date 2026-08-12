resource "openstack_networking_network_v2" "oac-fw-net" {
  provider       = openstack.admin
  name           = "oac-fw-net"
  admin_state_up = true
  shared         = true

  segments {
    network_type     = "vlan"
    segmentation_id  = 212
    physical_network = "datacentre"
  }
}

resource "openstack_networking_subnet_v2" "oac-fw-net" {
  provider    = openstack.admin
  name        = openstack_networking_network_v2.oac-fw-net.name
  network_id  = openstack_networking_network_v2.oac-fw-net.id
  cidr        = "10.20.0.0/24"
  enable_dhcp = false
  ip_version  = 4
}

data "openstack_identity_project_v3" "open-accelerator" {
  provider = openstack.admin
  name     = "open-accelerator"
}

resource "openstack_networking_port_v2" "oac-infra-port" {
  provider       = openstack.admin
  name           = "oac-infra-port"
  network_id     = openstack_networking_network_v2.oac-fw-net.id
  admin_state_up = "true"
  tenant_id      = data.openstack_identity_project_v3.open-accelerator.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.oac-fw-net.id
    ip_address = "10.20.0.20"
  }
}

resource "openstack_networking_port_v2" "oac-staging-port" {
  provider       = openstack.admin
  name           = "oac-staging-port"
  network_id     = openstack_networking_network_v2.oac-fw-net.id
  admin_state_up = "true"
  tenant_id      = data.openstack_identity_project_v3.open-accelerator.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.oac-fw-net.id
    ip_address = "10.20.0.40"
  }
}

resource "openstack_networking_port_v2" "oac-prod-port" {
  provider       = openstack.admin
  name           = "oac-prod-port"
  network_id     = openstack_networking_network_v2.oac-fw-net.id
  admin_state_up = "true"
  tenant_id      = data.openstack_identity_project_v3.open-accelerator.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.oac-fw-net.id
    ip_address = "10.20.0.60"
  }
}
