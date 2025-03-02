variable "location" {
  type = string
}

variable "rg_id" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "issuer_url" {
  type = string
}

variable "karpenter_k8s_namespace" {
  type = string
}

variable "karpenter_k8s_serviceaccount" {
  type = string
}

variable "node_rg_id" {
  type = string
}
