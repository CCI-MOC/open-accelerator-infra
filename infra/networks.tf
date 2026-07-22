locals {
  networks = {
    osac-infra = {
      cidr = "172.16.0.0/23"
      allocation_pool = {
        start = "172.16.0.10"
        end   = "172.16.0.255"
      }
    }
    osac-prod = {
      cidr = "172.16.2.0/23"
      allocation_pool = {
        start = "172.16.2.10"
        end   = "172.16.2.255"
      }
    }
  }
}

module "network" {
  source   = "./modules/network"
  for_each = local.networks

  name            = each.key
  cidr            = each.value.cidr
  allocation_pool = try(each.value.allocation_pool, null)
}
