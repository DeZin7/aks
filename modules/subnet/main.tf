data "azurerm_resource_group" "this" {
  name = var.rg_name
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  for_each                          = var.subnets
  name                              = each.value.name
  resource_group_name               = data.azurerm_resource_group.this.name
  virtual_network_name              = data.azurerm_virtual_network.this.name
  address_prefixes                  = each.value.address_prefixes
  private_endpoint_network_policies = each.value.private_endpoint_network_policies

  dynamic "delegation" {
    for_each = var.subnet_delegation
    content {
      name = each.value.name
      service_delegation {
        name    = each.value.service_delegation_name
        actions = each.value.service_delegation_actions
      }
    }
  }
}