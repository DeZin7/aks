data "azurerm_resource_group" "this" {
  name = var.rg_name
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.this.name
}

resource "azurerm_public_ip" "this" {
  name                = var.public_ip_name
  sku                 = var.public_ip_sku
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = var.public_ip_allocation_method
}

resource "azurerm_private_endpoint" "this" {
  name                = var.private_endpoint_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.this.id

  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names # -- list(string)
    is_manual_connection           = var.is_manual_connection
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = data.azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = data.azurerm_virtual_network.this.id
}