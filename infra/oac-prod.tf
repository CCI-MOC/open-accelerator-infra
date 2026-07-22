resource "ironic_allocation" "oac-prod-compute" {
  name  = "oac-prod-compute-${count.index}"
  count = 3

  resource_class = "fc830"
}

data "ironic_node" "oac-prod-compute" {
  count = length(ironic_allocation.oac-prod-compute)
  uuid  = ironic_allocation.oac-prod-compute[count.index].node_uuid
}

resource "ironic_allocation" "oac-prod-gpu" {
  name  = "oac-prod-gpu-${count.index}"
  count = 0

  resource_class = "lenovo-sd665nv3-h100"
}

data "ironic_node" "oac-prod-gpu" {
  count = length(ironic_allocation.oac-prod-gpu)
  uuid  = ironic_allocation.oac-prod-gpu[count.index].node_uuid
}
