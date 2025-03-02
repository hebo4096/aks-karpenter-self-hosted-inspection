variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "karpenter_log_level" {
  type    = string
  default = "debug"
}

variable "karpenter_k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace where you install karpenter (default will be 'kube-system')"
}

variable "azure_aks_resource_name" {
  type = string
}

variable "azure_aks_cluster_endpoint" {
  type = string
}

variable "azure_aks_ssh_public_key" {
  type = string
}

variable "azure_aks_network_plugin" {
  type = string
}

variable "azure_aks_network_plugin_mode" {
  type = string
}

variable "azure_aks_network_policy" {
  type = string
}

variable "azure_aks_subnet_id" {
  type = string
}

variable "azure_aks_vnet_guid" {
  type = string
}

variable "azure_aks_kubeletid_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "azure_location" {
  type = string
}

variable "azure_aks_node_resource_group_name" {
  type = string
}

variable "azure_karpenter_umi_client_id" {
  type = string
}

variable "kubernetes_karpenter_serviceaccount_name" {
  type = string
}
