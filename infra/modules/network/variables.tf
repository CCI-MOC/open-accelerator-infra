variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "ip_version" {
  type    = number
  default = 4
}

variable "external_network" {
  type    = string
  default = "external"
}

variable "allocation_pool" {
  type = object({
    start = string
    end   = string
  })
  default = null
}
