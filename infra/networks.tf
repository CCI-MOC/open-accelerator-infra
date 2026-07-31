locals {
  networks = {
    oac-infra = {
      cidr = "10.20.2.0/23"
      allocation_pool = {
        start = "10.20.2.10"
        end   = "10.20.2.255"
      }
      extra_ports = [
        "oac-infra-port",
      ]
      extra_routes = [
        {
          destination = "10.208.0.0/23"
          gateway     = "10.20.0.1"
        }
      ]
    }
    oac-staging = {
      cidr = "10.20.4.0/23"
      allocation_pool = {
        start = "10.20.4.10"
        end   = "10.20.4.255"
      }
      extra_ports = [
        "oac-staging-port",
      ]
      extra_routes = [
        {
          destination = "10.208.0.0/23"
          gateway     = "10.20.0.1"
        }
      ]
    }
    oac-prod = {
      cidr = "10.20.6.0/23"
      allocation_pool = {
        start = "10.20.6.10"
        end   = "10.20.6.255"
      }
      extra_ports = [
        "oac-prod-port",
      ]
      extra_routes = [
        {
          destination = "10.208.0.0/23"
          gateway     = "10.20.0.1"
        }
      ]
    }
  }
}

module "network" {
  source   = "./modules/network"
  for_each = local.networks

  name            = each.key
  cidr            = each.value.cidr
  allocation_pool = try(each.value.allocation_pool, null)
  extra_ports     = each.value.extra_ports
  extra_routes    = each.value.extra_routes
}

output "network_ids" {
  description = "Map of network names to their IDs"
  value       = { for k, v in module.network : k => v.network_id }
}

