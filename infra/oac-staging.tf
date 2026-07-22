resource "ironic_allocation" "oac-staging-compute" {
  name  = "oac-staging-compute-${count.index}"
  count = 3

  resource_class = "fc830"
}

data "ironic_node" "oac-staging-compute" {
  count = length(ironic_allocation.oac-staging-compute)
  uuid  = ironic_allocation.oac-staging-compute[count.index].node_uuid
}
