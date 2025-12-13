output "virtual_network_id" {
  value = data.azurerm_virtual_network.this
}

output "subnet_id" {
  value = data.azurerm_subnet.this.id
}

output "public_ip_address_id" {
  value = azurerm_public_ip.this[0].id
}

output "public_ip_address_ip" {
  value = azurerm_public_ip.this[0].ip_address
}

output "public_ip_address_fqdn" {
  value = azurerm_public_ip.this[0].fqdn
}