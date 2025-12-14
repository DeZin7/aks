resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.rg_name
  location = var.rg_location
}

data "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 0 : 1
  name  = var.rg_name
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = coalesce(try(data.azurerm_resource_group.this[0].location, null), try(azurerm_resource_group.this[0].location, null))
  resource_group_name = coalesce(try(data.azurerm_resource_group.this[0].name, null), try(azurerm_resource_group.this[0].name, null))
  address_space       = var.vnet_address_space
  dns_servers         = var.vnet_dns_servers
  tags                = var.tags
}