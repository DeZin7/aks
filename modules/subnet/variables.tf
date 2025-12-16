variable "rg_name" {
  description = "The resource group name."
  type        = string
}

variable "vnet_name" {
  description = "The vnet name."
  type        = string
}

variable "subnet_name" {
  description = "The subnet name."
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The subnet CIDR."
  type        = list(string)
}

variable "subnets" {
  type = map(object({
    name                              = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = string
  }))
}

variable "subnet_delegation" {
  type = map(object({
    name                       = string
    service_delegation_name    = string
    service_delegation_actions = list(string)
  }))
}