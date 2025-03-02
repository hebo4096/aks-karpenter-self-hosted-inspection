locals {
  aks_umi_role_list = [
    "Network Contributor"
  ]
}


resource "tls_private_key" "rsa4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_user_assigned_identity" "aks" {
  resource_group_name = var.rg_name
  location            = var.location
  name                = "aks-umi"
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "karpenter"
  location            = var.location
  resource_group_name = var.rg_name

  depends_on = [
    tls_private_key.rsa4096
  ]

  dns_prefix = "karpenter-demo"

  default_node_pool {
    name           = "systemnp"
    vm_size        = "Standard_DS2_v2"
    node_count     = 1
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "cilium"
    network_data_plane  = "cilium"
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = tls_private_key.rsa4096.public_key_openssh
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks.id
    ]
  }

  # OIDC and Workload Identßity settings
  workload_identity_enabled = true
  oidc_issuer_enabled       = true
}

resource "azurerm_role_assignment" "aks_rg" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  for_each = { for i, role in local.aks_umi_role_list : i => role }

  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  scope                = var.rg_id
  role_definition_name = each.value
}

resource "azurerm_role_assignment" "aks_node_rg" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  for_each = { for i, role in local.aks_umi_role_list : i => role }

  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  scope                = azurerm_kubernetes_cluster.this.node_resource_group_id
  role_definition_name = each.value
}
