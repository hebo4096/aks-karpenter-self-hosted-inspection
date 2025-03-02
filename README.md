# aks-karpenter-self-hosted-inspection

## Overview
Deploy AKS cluster with Karpenter installed with terraform.
Uses self-hosted method to install.

for more details, see -> https://github.com/Azure/karpenter-provider-azure

> [!NOTE]
> This code installs Karpenter with Karpenter Provider for Azure v0.7.3

## Prerequisites
- CLI needed to follow the steps
  - [azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
  - [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  - [kubectl CLI](https://kubernetes.io/ja/docs/tasks/tools/#kubectl)
  
## steps to deploy
1, Initialize terraform for `azure` directory

```
terraform -chdir=azure init
```

2, Deploy Azure resources

```
terraform -chdir=azure apply
```

4, keep the output result

```
azure_aks_cluster_endpoint = "https://xxxxxxxxxxx.hcp.japaneast.azmk8s.io:443"
azure_aks_kubeletid_id = "/subscriptions/yyyyyyyyyyyyy/resourceGroups/MC_karpenter-rg_karpenter_japaneast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/karpenter-agentpool"
azure_aks_network_plugin = "azure"
azure_aks_network_plugin_mode = "overlay"
...
karpenter_k8s_namespace = "kube-system"
kubernetes_karpenter_serviceaccount_name = "karpenter-sa"

```

4, set cluster context to local `.kube/config` file

```
az aks get-credentials -n karpenter -g karpenter-rg
```
5, create `kubernetes/terraform.tfvars` file with the output of step 3

```
azure_aks_cluster_endpoint = "https://xxxxxxxxxxx.hcp.japaneast.azmk8s.io:443"
azure_aks_kubeletid_id = "/subscriptions/yyyyyyyyyyyyy/resourceGroups/MC_karpenter-rg_karpenter_japaneast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/karpenter-agentpool"
azure_aks_network_plugin = "azure"
azure_aks_network_plugin_mode = "overlay"
...
karpenter_k8s_namespace = "kube-system"
kubernetes_karpenter_serviceaccount_name = "karpenter-sa"
```

6, Initialize terraform for `kubernetes` directory

```
terraform -chdir=kubernetes init
```

7, Deploy Kubernetes resources
```
terraform -chdir=kubernetes apply
```

8, customize the Custom Resources (NodePool, AKSNodeClass) according to step [here](
https://gihub.com/Azure/karpenter-provider-azure/#using-karpenter-self-hosted)

9, try out node scaling by Karpenter according to step [here](https://github.com/Azure/karpenter-provider-azure/#scale-up-deployment)
