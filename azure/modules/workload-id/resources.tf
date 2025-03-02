# Workload ID configuration for karpenter
locals {
  karpenter_role_list = [
    "Virtual Machine Contributor",
    "Network Contributor",
    "Managed Identity Operator"
  ]
}

resource "azurerm_user_assigned_identity" "karpenter" {
  name                = "karpenter-umi"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_federated_identity_credential" "karpenter" {
  name                = "karpenter-fid"
  resource_group_name = var.rg_name

  parent_id = azurerm_user_assigned_identity.karpenter.id

  issuer  = var.issuer_url
  subject = "system:serviceaccount:${var.karpenter_k8s_namespace}:${var.karpenter_k8s_serviceaccount}"
  audience = [
    "api://AzureADTokenExchange"
  ]
}

resource "azurerm_role_assignment" "karpenter_rg" {
  principal_id         = azurerm_user_assigned_identity.karpenter.principal_id
  scope                = var.rg_id
  role_definition_name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "karpenter_node_rg" {
  for_each = { for i, role in local.karpenter_role_list : i => role }

  principal_id         = azurerm_user_assigned_identity.karpenter.principal_id
  scope                = var.node_rg_id
  role_definition_name = each.value
}

