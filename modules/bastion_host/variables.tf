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

variable "vnet_rg" {
  description = "The vnet resource group."
  type        = string
}

variable "subnet_name" {
  description = "The subnet name."
  type        = string
}

variable "subnet_rg" {
  description = "The subnet resource group."
  type        = string
}

variable "create_publicip" {
  description = "Would you like to create an Azure public ip address?"
  type        = bool
  default     = false
}

variable "public_ip_address_name" {
  description = "The public ip address name."
  type        = string
}

variable "public_ip_address_id" {
  description = "If using an existent public ip adress, provide the public ip address id."
  type        = string
}

variable "public_ip_allocation_method" {
  description = "The azure public ip allocation method."
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "The azure public ip sku."
  type        = string
  default     = "Basic"
}

variable "bastion_host_name" {
  description = "The name of the bastion host."
  type        = string
}

variable "public_ip_location" {
  description = "The public ip location."
  type        = string
}

variable "public_ip_rg_name" {
  description = "The public ip resource group name."
  type        = string
}

variable "bastion_location" {
  description = "The bastion host location."
  type        = string
}

variable "bastion_rg_name" {
  description = "The bastion host resource group name."
  type        = string
}

variable "bastion_publicip_id" {
  description = "The bastion host public ip id."
  type        = string
}