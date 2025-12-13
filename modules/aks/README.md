# AKS Terraform Module

This module provisions a **production-ready Azure Kubernetes Service (AKS) cluster** using **OpenTofu / Terraform**, with support for:

- ✅ Private and public AKS clusters  
- ✅ User-assigned managed identity  
- ✅ GitOps-friendly configuration  
- ✅ Azure AD / Azure RBAC integration  
- ✅ Application Gateway Ingress (optional)  
- ✅ Log Analytics + Diagnostics  
- ✅ Workload autoscaling (KEDA + VPA)  
- ✅ Secure networking (custom subnets, UDR, DNS)  

It is designed for **platform teams** managing **multi-environment Kubernetes clusters** at scale.

---

## 🚀 Basic Usage

```hcl
module "aks" {
  source = "./modules/aks"

  name                = "prod-aks"
  location            = "eastus"
  resource_group_name = "prod-k8s-rg"
  dns_prefix          = "prod"

  private_cluster_enabled      = true
  automatic_upgrade_channel   = "patch"
  sku_tier                     = "Paid"
  workload_identity_enabled   = true
  oidc_issuer_enabled         = true
  open_service_mesh_enabled   = false
  image_cleaner_enabled       = true
  image_cleaner_interval_hours = 48
  azure_policy_enabled        = true
  http_application_routing_enabled = false

  default_node_pool_name  = "system"
  default_node_pool_vm_size = "Standard_D4s_v5"
  default_node_pool_node_auto_scaling_enabled = true
  default_node_pool_node_min_count = 2
  default_node_pool_node_max_count = 6
  default_node_pool_node_max_pods  = 30
  default_node_pool_node_count    = 3
  default_node_pool_node_host_encryption_enabled = true
  default_node_pool_node_node_public_ip_enabled = false

  vnet_subnet_id = var.node_subnet_id
  pod_subnet_id  = var.pod_subnet_id

  admin_username = "azureuser"
  ssh_key        = file("~/.ssh/id_rsa.pub")

  network_plugin         = "azure"
  outbound_type          = "userDefinedRouting"
  network_dns_service_ip = "10.0.0.10"
  network_service_cidr   = "10.0.0.0/16"

  log_analytics_workspace_id = var.log_analytics_workspace_id

  tenant_id                = var.tenant_id
  admin_group_object_ids   = var.admin_group_ids
  azure_rbac_enabled       = true

  keda_enabled                     = true
  vertical_pod_autoscaler_enabled  = true

  tags = {
    environment = "prod"
    owner       = "platform"
  }
}
```

---

## 🌐 Optional: Application Gateway Ingress (AGIC)

To enable Application Gateway integration:

```hcl
ingress_application_gateway = {
  gateway_id  = var.appgw_id
  subnet_cidr = "10.10.0.0/24"
  subnet_id   = var.appgw_subnet_id
}
```

If `gateway_id` is `null`, the integration is automatically skipped.

---

## 📊 Optional: Diagnostic Logs to Storage Account

```hcl
storage_account_id = var.diagnostic_storage_account_id
```

If `null`, logs will only go to Log Analytics.

---

## 📥 Inputs (High-Level)

| Name | Type | Description |
|------|------|-------------|
| `name` | `string` | AKS cluster name |
| `location` | `string` | Azure region where the cluster will be deployed |
| `resource_group_name` | `string` | Resource group for the AKS cluster |
| `dns_prefix` | `string` | DNS prefix for the AKS cluster |
| `private_cluster_enabled` | `bool` | Enable private AKS cluster |
| `automatic_upgrade_channel` | `string` | AKS automatic upgrade channel (patch, stable, rapid, none) |
| `sku_tier` | `string` | AKS SKU tier (Free or Paid) |
| `workload_identity_enabled` | `bool` | Enable workload identity |
| `oidc_issuer_enabled` | `bool` | Enable OIDC issuer |
| `open_service_mesh_enabled` | `bool` | Enable Open Service Mesh |
| `image_cleaner_enabled` | `bool` | Enable AKS image cleaner |
| `image_cleaner_interval_hours` | `number` | Image cleaner interval (hours) |
| `azure_policy_enabled` | `bool` | Enable Azure Policy addon |
| `http_application_routing_enabled` | `bool` | Enable HTTP Application Routing |

### Default Node Pool

| Name | Type | Description |
|------|------|-------------|
| `default_node_pool_name` | `string` | Default node pool name |
| `default_node_pool_vm_size` | `string` | VM size for default node pool |
| `default_node_pool_node_auto_scaling_enabled` | `bool` | Enable autoscaling |
| `default_node_pool_node_min_count` | `number` | Minimum node count |
| `default_node_pool_node_max_count` | `number` | Maximum node count |
| `default_node_pool_node_count` | `number` | Fixed node count (when autoscaling is disabled) |
| `default_node_pool_node_max_pods` | `number` | Max pods per node |
| `default_node_pool_node_host_encryption_enabled` | `bool` | Enable host disk encryption |
| `default_node_pool_node_node_public_ip_enabled` | `bool` | Enable public IP per node |
| `default_node_pool_availability_zones` | `list(string)` | Availability zones |
| `default_node_pool_node_labels` | `map(string)` | Node labels |
| `vnet_subnet_id` | `string` | Subnet ID for AKS nodes |
| `pod_subnet_id` | `string` | Subnet ID for pod networking |

### Networking

| Name | Type | Description |
|------|------|-------------|
| `network_plugin` | `string` | Network plugin (azure or kubenet) |
| `outbound_type` | `string` | Outbound traffic type |
| `network_dns_service_ip` | `string` | DNS service IP |
| `network_service_cidr` | `string` | Service CIDR range |

### Identity & Access

| Name | Type | Description |
|------|------|-------------|
| `tenant_id` | `string` | Azure AD tenant ID |
| `admin_group_object_ids` | `list(string)` | Azure AD admin group object IDs |
| `azure_rbac_enabled` | `bool` | Enable Azure RBAC |
| `admin_username` | `string` | Linux admin username |
| `ssh_key` | `string` | SSH public key for nodes |

### Monitoring & Diagnostics

| Name | Type | Description |
|------|------|-------------|
| `log_analytics_workspace_id` | `string` | Log Analytics workspace ID |
| `storage_account_id` | `string` | Optional storage account for diagnostics |

### Ingress (Optional)

| Name | Type | Description |
|------|------|-------------|
| `ingress_application_gateway.gateway_id` | `string` | Application Gateway ID |
| `ingress_application_gateway.subnet_cidr` | `string` | Subnet CIDR for AGIC |
| `ingress_application_gateway.subnet_id` | `string` | Subnet ID for AGIC |

### Autoscaling

| Name | Type | Description |
|------|------|-------------|
| `keda_enabled` | `bool` | Enable KEDA autoscaler |
| `vertical_pod_autoscaler_enabled` | `bool` | Enable Vertical Pod Autoscaler |

### General

| Name | Type | Description |
|------|------|-------------|
| `tags` | `map(string)` | Resource tags applied to all resources |


---

## 📤 Outputs

| Name | Description |
|------|-------------|
| `name` | The name of the AKS cluster. |
| `id` | The full Azure resource ID of the AKS cluster. |
| `aks_identity_principal_id` | The principal ID of the user-assigned managed identity used by the AKS cluster. |
| `kubelet_identity_object_id` | The object ID of the kubelet identity associated with the AKS cluster. |
| `kube_config_raw` | Raw Kubernetes config (kubeconfig) for authenticating `kubectl` and other Kubernetes clients. |
| `private_fqdn` | Internal private FQDN of the AKS cluster (only set when private cluster is enabled). |
| `node_resource_group` | The auto-generated Azure resource group name that contains the AKS node resources. |
