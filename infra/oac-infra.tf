resource "ironic_allocation" "oac-infra" {
  name  = "oac-infra-${count.index}"
  count = 3

  resource_class = "fc830"
}

data "ironic_node" "oac-infra" {
  count = length(ironic_allocation.oac-infra)
  uuid  = ironic_allocation.oac-infra[count.index].node_uuid
}

resource "ironic_deployment" "oac-infra" {
  count     = var.deploy ? 3 : 0
  node_uuid = element(ironic_allocation.oac-infra.*.node_uuid, count.index)

  instance_info = {
    deploy_interface = "ramdisk"
    boot_iso         = "http://www.tinycorelinux.net/17.x/x86/release/TinyCore-current.iso"
  }
}
