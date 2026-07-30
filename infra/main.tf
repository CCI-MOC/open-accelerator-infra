terraform {
  required_version = ">= 1.9.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    ironic = {
      source  = "registry.terraform.io/metal3-community/ironic"
      version = "~> 1.0.0"
    }
  }
}

provider "ironic" {
  auth_strategy = "keystone"
  microversion  = "1.72"
}

variable "boot_image" {
  type    = string
  default = "https://southfront.mm.fcix.net/fedora/linux/releases/44/Workstation/x86_64/iso/Fedora-Workstation-Live-44-1.7.x86_64.iso"
}
