variable "rg_name" {
  description = "Name of the existing Azure Resource Group where resources will be created/queried."
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing Virtual Network that contains the subnet for the private endpoint."
  type        = string
}

variable "subnet_name" {
  description = "Name of the existing subnet where the private endpoint will be placed."
  type        = string
}

variable "public_ip_name" {
  description = "Name of the Public IP resource to create."
  type        = string
}

variable "public_ip_sku" {
  description = "SKU of the Public IP. Common values: \"Standard\" or \"Basic\"."
  type        = string
  default     = "Standard"
}

variable "public_ip_allocation_method" {
  description = "Allocation method for the Public IP. Common values: \"Static\" or \"Dynamic\" (Standard typically requires Static)."
  type        = string
  default     = "Static"
}

variable "private_endpoint_name" {
  description = "Name of the Private Endpoint resource to create."
  type        = string
}

variable "private_service_connection_name" {
  description = "Name of the Private Service Connection inside the Private Endpoint."
  type        = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the Azure service to connect to via Private Endpoint (e.g., Storage Account, Key Vault, Cosmos DB, etc.)."
  type        = string
}

variable "subresource_names" {
  description = "List of subresource names (group IDs) for the target resource (e.g., [\"blob\"] for Storage)."
  type        = list(string)
}

variable "is_manual_connection" {
  description = "Whether the Private Endpoint connection requires manual approval (true) or automatic approval (false)."
  type        = bool
  default     = false
}

variable "private_dns_zone_group_name" {
  description = "Name of the Private DNS Zone Group attached to the Private Endpoint."
  type        = string
  default     = "default"
}

variable "private_dns_zone_name" {
  description = "Name of the Private DNS Zone to create (e.g., \"privatelink.blob.core.windows.net\")."
  type        = string
}

variable "private_dns_zone_virtual_network_link_name" {
  description = "Name of the Private DNS Zone Virtual Network Link resource."
  type        = string
}
