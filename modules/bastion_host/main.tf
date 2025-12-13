resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.rg_name
  location = var.rg_location
}

data "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 0 : 1
  name  = var.rg_name
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = var.subnet_rg
}

locals {
  public_ip_location  = coalesce(var.public_ip_location, try(azurerm_resource_group.this[0].location, null))
  public_ip_rg_name   = coalesce(var.public_ip_rg_name, try(azurerm_resource_group.this[0].name, null))
  bastion_location    = coalesce(var.bastion_location, try(azurerm_resource_group.this[0].location, null))
  bastion_rg_name     = coalesce(var.bastion_rg_name, try(azurerm_resource_group.this[0].name, null))
  bastion_publicip_id = coalesce(var.public_ip_address_id, try(azurerm_public_ip.this[0].id, null))
}

resource "azurerm_public_ip" "this" {
  count               = var.create_publicip ? 1 : 0
  name                = var.public_ip_address_name
  location            = local.public_ip_location
  resource_group_name = local.public_ip_rg_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_bastion_host" "this" {
  name                = var.bastion_host_name
  location            = local.bastion_location
  resource_group_name = local.bastion_rg_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.this.id
    public_ip_address_id = local.bastion_publicip_id
  }
}