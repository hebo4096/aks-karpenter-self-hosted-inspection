output "node_rg_id" {
  value = azurerm_kubernetes_cluster.this.node_resource_group_id
}

output "resource_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "cluster_endpoint" {
  value = azurerm_kubernetes_cluster.this.fqdn
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

# TODO: check how to get parameter
output "ssh_public_key" {
  value = azurerm_kubernetes_cluster.this.linux_profile[0].ssh_key[0].key_data
}

output "network_plugin" {
  value = azurerm_kubernetes_cluster.this.network_profile[0].network_plugin
}

output "network_plugin_mode" {
  value = azurerm_kubernetes_cluster.this.network_profile[0].network_plugin_mode
}

output "network_policy" {
  value = azurerm_kubernetes_cluster.this.network_profile[0].network_policy
}

# TODO: check how to get resource id
output "kubeletid_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity[0].user_assigned_identity_id
}
