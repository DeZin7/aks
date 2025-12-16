output "id" {
  value = data.azurerm_resource_group.this.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.this.id
}