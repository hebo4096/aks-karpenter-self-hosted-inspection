# outputs will be used for the kubernetes installation
# create terraform.tfvars file under kubernetes/ directory, which uses output
output "azure_subscription_id" {
  value = var.subscription_id
}

output "azure_location" {
  value = var.location
}

output "karpenter_k8s_namespace" {
  value = var.karpenter_k8s_namespace
}

output "kubernetes_karpenter_serviceaccount_name" {
  value = var.karpenter_k8s_serviceaccount
}

output "azure_aks_node_resource_group_name" {
  value = regex(".*resourceGroups/([^/]+)", module.aks.node_rg_id)[0]
}

output "azure_aks_resource_name" {
  value = module.aks.resource_name
}

output "azure_aks_cluster_endpoint" {
  value = "https://${module.aks.cluster_endpoint}:443"
}

output "azure_aks_ssh_public_key" {
  value = trimspace(module.aks.ssh_public_key)
}

output "azure_aks_network_plugin" {
  value = module.aks.network_plugin
}

output "azure_aks_network_plugin_mode" {
  value = module.aks.network_plugin_mode != null ? module.aks.network_plugin_mode : ""
}

output "azure_aks_network_policy" {
  value = module.aks.network_policy
}

output "azure_aks_kubeletid_id" {
  value = module.aks.kubeletid_id
}

output "azure_karpenter_umi_client_id" {
  value = module.workload_id.karpenter_umi_client_id
}

output "azure_aks_subnet_id" {
  value = module.network.aks_subnet_id
}

output "azure_aks_vnet_guid" {
  value = module.network.vnet_guid
}
