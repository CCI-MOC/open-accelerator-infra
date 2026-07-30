resource "ironic_allocation" "oac-bastion" {
  name  = "oac-bastion-${count.index}"
  count = 1

  resource_class = "fc430"
}

data "ironic_node" "oac-bastion" {
  count = length(ironic_allocation.oac-bastion)
  uuid  = ironic_allocation.oac-bastion[count.index].node_uuid
}

resource "ironic_deployment" "oac-bastion" {
  count     = var.deploy ? 1 : 0
  node_uuid = element(ironic_allocation.oac-bastion.*.node_uuid, count.index)

  instance_info = {
    deploy_interface = "ramdisk"
    boot_iso         = var.boot_image
  }
}
