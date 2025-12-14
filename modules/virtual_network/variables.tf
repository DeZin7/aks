variable "create_resource_group" {
  description = "Would you like to create a resource group?"
  type        = bool
  default     = false
}

variable "rg_name" {
  description = "The resource group name."
  type        = string
}

variable "rg_location" {
  description = "The resource group location."
  type        = string
}

variable "vnet_name" {
  description = "The vnet name."
  type        = string
}

variable "vnet_address_space" {
  description = "The vnet CIDR block."
  type        = list(string)
}

variable "vnet_dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources created by this module."
  type        = map(string)
  default = {
    "createdWith" = "Terraform/OpenTofu"
    "environment" = "dev"
  }
}