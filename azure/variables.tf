variable "subscription_id" {
  type        = string
  description = "Your Subscription's ID to deploy resources"
}

variable "location" {
  type        = string
  default     = "japaneast"
  description = "Which region to deploy resources (default will be 'japaneast')"
}

variable "karpenter_k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace where you install karpenter (default will be 'kube-system')"
}

variable "karpenter_k8s_serviceaccount" {
  type        = string
  default     = "karpenter-sa"
  description = "Kubernetes serviceaccount used for karpenter (default will be 'karpenter-sa')"
}
