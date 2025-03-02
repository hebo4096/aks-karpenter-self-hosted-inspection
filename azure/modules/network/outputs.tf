output "aks_vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "vnet_guid" {
  value = azurerm_virtual_network.this.guid
}
