output "network_id" {
  description = "Network UUID"
  value       = openstack_networking_network_v2.this.id
}
