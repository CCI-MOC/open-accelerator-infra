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
  default = "https://fedora.mirror.constant.com/fedora/linux/releases/44/Server/x86_64/iso/Fedora-Server-netinst-x86_64-44-1.7.iso"
}
