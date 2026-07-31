variable "name" {
  type        = string
  description = "The network name (also used as the subnet name)"
}

variable "cidr" {
  type        = string
  description = "Network address range in cidr address/prefix format"
  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "Must be valid CIDR notation (e.g., 10.0.0.0/16)."
  }
}

variable "ip_version" {
  type        = number
  default     = 4
  description = "IP protocol version used on this network"
  validation {
    condition     = contains([4, 6], var.ip_version)
    error_message = "Must be 4 (for ipv4) or 6 (for ipv6)"
  }
}

variable "external_network" {
  type        = string
  default     = "external"
  description = "Name of network that will be configured as router external gateway"
}

variable "allocation_pool" {
  type = object({
    start = string
    end   = string
  })
  description = "Set range of addresses assigned to hosts using DHCP"
  default     = null
  validation {
    condition = var.allocation_pool == null || (
      can(cidrhost("${var.allocation_pool.start}/32", 0)) &&
      can(cidrhost("${var.allocation_pool.end}/32", 0))
    )
    error_message = "Start and end addresses must be valid IP addresses."
  }
}

variable "extra_ports" {
  type        = list(string)
  default     = []
  description = "A list of extra ports to be attached to the router"
}

variable "extra_routes" {
  type = list(object({
    destination = string
    gateway     = string
  }))
  default     = []
  description = "A list of extra routes to be configured on the router"
  validation {
    condition = alltrue([
      for route in var.extra_routes :
      can(cidrhost(route.destination, 0)) || can(cidrhost("${route.destination}/32", 0))
    ])
    error_message = "Each destination must be a valid IP address or CIDR block (e.g., 10.0.0.1 or 10.0.0.0/16)."
  }
  validation {
    condition = alltrue([
      for route in var.extra_routes :
      can(cidrhost("${route.gateway}/32", 0))
    ])
    error_message = "Each gateway must be a valid IP address."
  }
}
