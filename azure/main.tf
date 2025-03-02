resource "azurerm_resource_group" "this" {
  name     = "karpenter-rg"
  location = var.location
}

module "network" {
  source = "./modules/network"

  location = var.location
  rg_name  = azurerm_resource_group.this.name
}

module "aks" {
  source = "./modules/aks"
  depends_on = [
    module.network
  ]

  location  = var.location
  rg_id     = azurerm_resource_group.this.id
  rg_name   = azurerm_resource_group.this.name
  vnet_id   = module.network.aks_vnet_id
  subnet_id = module.network.aks_subnet_id
}

module "workload_id" {
  source = "./modules/workload-id"
  depends_on = [
    module.network,
    module.aks
  ]

  location = var.location
  rg_id    = azurerm_resource_group.this.id
  rg_name  = azurerm_resource_group.this.name

  # depends on created AKS resource
  node_rg_id = module.aks.node_rg_id
  issuer_url = module.aks.oidc_issuer_url

  karpenter_k8s_namespace      = var.karpenter_k8s_namespace
  karpenter_k8s_serviceaccount = var.karpenter_k8s_serviceaccount
}
