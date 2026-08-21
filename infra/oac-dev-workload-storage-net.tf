resource "openstack_networking_network_v2" "oac-dev-workload-storage-net" {
  provider       = openstack.admin
  name           = "oac-dev-workload-storage-net"
  admin_state_up = true
  shared         = true

  segments {
    network_type     = "vlan"
    segmentation_id  = 2314
    physical_network = "datacentre"
  }
}

resource "openstack_networking_subnet_v2" "oac-dev-workload-storage-net" {
  provider    = openstack.admin
  name        = openstack_networking_network_v2.oac-dev-workload-storage-net.name
  network_id  = openstack_networking_network_v2.oac-dev-workload-storage-net.id
  cidr        = "10.9.4.0/24"
  enable_dhcp = false
  ip_version  = 4
}
