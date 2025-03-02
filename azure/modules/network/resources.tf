resource "azurerm_virtual_network" "this" {
  name                = "karpenter-demo-vnet"
  location            = var.location
  resource_group_name = var.rg_name

  address_space = [
    "10.0.0.0/8"
  ]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [
    "10.240.0.0/16"
  ]

  depends_on = [
    azurerm_virtual_network.this
  ]
}
