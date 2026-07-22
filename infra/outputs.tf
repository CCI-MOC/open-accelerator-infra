output "network_ids" {
  description = "Map of network names to their IDs"
  value       = { for k, v in module.network : k => v.network_id }
}

output "oac-bastion-nodes" {
  description = "List of nodes allocated to oac-bastion cluster"
  value = [for i, a in ironic_allocation.oac-bastion : {
    name      = a.name
    id        = a.node_uuid
    node_name = data.ironic_node.oac-bastion[i].name
  }]
}

output "oac-infra-nodes" {
  description = "List of nodes allocated to oac-infra cluster"
  value = [for i, a in ironic_allocation.oac-infra : {
    name      = a.name
    id        = a.node_uuid
    node_name = data.ironic_node.oac-infra[i].name
  }]
}

output "oac-prod-compute-nodes" {
  description = "List of compute nodes allocated to oac-prod cluster"
  value = [for i, a in ironic_allocation.oac-prod-compute : {
    name      = a.name
    id        = a.node_uuid
    node_name = data.ironic_node.oac-prod-compute[i].name
  }]
}

output "oac-prod-gpu-nodes" {
  description = "List of gpu nodes allocated to oac-prod cluster"
  value = [for i, a in ironic_allocation.oac-prod-gpu : {
    name      = a.name
    id        = a.node_uuid
    node_name = data.ironic_node.oac-prod-gpu[i].name
  }]
}
