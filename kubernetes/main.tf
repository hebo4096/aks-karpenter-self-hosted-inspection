# https://github.com/Azure/karpenter-provider-azure/blob/main/hack/deploy/configure-values.sh#L28-L30
# Parse bootstrap token from secrets in kube-system namespace.
# This secret should only exist one.
data "kubernetes_resources" "kube_system_secrets" {
  api_version    = "v1"
  namespace      = "kube-system"
  kind           = "Secret"
  field_selector = "type=bootstrap.kubernetes.io/token"
}

locals {
  # bootstrap token
  bootstrap_token_secrets = data.kubernetes_resources.kube_system_secrets
  bootstrap_id            = base64decode(local.bootstrap_token_secrets.objects[0].data.token-id)
  bootstrap_secret        = base64decode(local.bootstrap_token_secrets.objects[0].data.token-secret)
  bootstrap_token         = "${local.bootstrap_id}.${local.bootstrap_secret}"

  # ssh public key
  ssh_public_key = "${var.azure_aks_ssh_public_key} azureuser"
}

# helm values setting for karpenter v0.7.3
# see -> https://raw.githubusercontent.com/Azure/karpenter/v0.7.3/karpenter-values-template.yaml
resource "helm_release" "karpenter" {
  name      = "karpenter"
  chart     = "oci://mcr.microsoft.com/aks/karpenter/karpenter"
  version   = "0.7.3"
  namespace = var.karpenter_k8s_namespace

  values = [
    <<-EOF
  replicas: 1
  controller:
    env:
      - name: DISABLE_LEADER_ELECTION
        value: "true"
      - name: CLUSTER_NAME
        value: ${var.azure_aks_resource_name}
      - name: CLUSTER_ENDPOINT
        value: ${var.azure_aks_cluster_endpoint}
      - name: KUBELET_BOOTSTRAP_TOKEN
        value: ${local.bootstrap_token}
      - name: SSH_PUBLIC_KEY
        value: "${local.ssh_public_key}"
      - name: NETWORK_PLUGIN
        value: ${var.azure_aks_network_plugin}
      - name: NETWORK_PLUGIN_MODE
        value: ${var.azure_aks_network_plugin_mode}
      - name: NETWORK_POLICY
        value: ${var.azure_aks_network_policy}
      - name: VNET_SUBNET_ID
        value: ${var.azure_aks_subnet_id}
      - name: VNET_GUID
        value: ${var.azure_aks_vnet_guid}
      - name: NODE_IDENTITIES
        value: ${var.azure_aks_kubeletid_id}
      # Azure client settings
      - name: ARM_SUBSCRIPTION_ID
        value: ${var.azure_subscription_id}
      - name: LOCATION
        value: ${var.azure_location}
      - name: KUBELET_IDENTITY_CLIENT_ID
        value: ""
      - name: AZURE_NODE_RESOURCE_GROUP
        value: ${var.azure_aks_node_resource_group_name}
      # managed karpenter settings
      - name: USE_SIG
        value: "false"
      - name: SIG_SUBSCRIPTION_ID
        value: ""
  serviceAccount:
    name: ${var.kubernetes_karpenter_serviceaccount_name}
    annotations:
      azure.workload.identity/client-id: ${var.azure_karpenter_umi_client_id}
  podLabels:
    azure.workload.identity/use: "true"
  logLevel: ${var.karpenter_log_level}
  EOF
  ]
}
