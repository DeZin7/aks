variable "location" {
  description = "Azure region where the AKS cluster and related resources will be deployed (e.g., eastus)."
  type        = string
}

variable "name" {
  description = "Base name for the AKS cluster and related resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the AKS cluster and related resources will be created."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "private_cluster_enabled" {
  description = "Whether to enable private cluster mode for AKS."
  type        = bool
}

variable "automatic_upgrade_channel" {
  description = "Automatic upgrade channel for AKS (e.g., patch, rapid, stable, none)."
  type        = string
}

variable "sku_tier" {
  description = "SKU tier for the AKS cluster (e.g., Free, Paid)."
  type        = string
}

variable "workload_identity_enabled" {
  description = "Whether to enable workload identity for AKS."
  type        = bool
}

variable "oidc_issuer_enabled" {
  description = "Whether to enable OIDC issuer for AKS."
  type        = bool
}

variable "open_service_mesh_enabled" {
  description = "Whether to enable Open Service Mesh (OSM) on the AKS cluster."
  type        = bool
}

variable "image_cleaner_enabled" {
  description = "Whether to enable the AKS image cleaner."
  type        = bool
}

variable "image_cleaner_interval_hours" {
  description = "Interval in hours at which the AKS image cleaner runs."
  type        = number
}

variable "azure_policy_enabled" {
  description = "Whether to enable Azure Policy addon for AKS."
  type        = bool
}

variable "http_application_routing_enabled" {
  description = "Whether to enable HTTP application routing addon for AKS."
  type        = bool
}

variable "default_node_pool_name" {
  description = "Name of the default node pool for the AKS cluster."
  type        = string
}

variable "default_node_pool_vm_size" {
  description = "VM size of the default node pool."
  type        = string
}

variable "only_critical_addons_enabled" {
  description = "Whether to enable only critical addons on the default node pool."
  type        = bool
}

variable "vnet_subnet_id" {
  description = "ID of the subnet where the AKS node pool will be deployed."
  type        = string
}

variable "pod_subnet_id" {
  description = "ID of the subnet used for pod IPs (Azure CNI)."
  type        = string
}

variable "default_node_pool_availability_zones" {
  description = "List of availability zones for the default node pool."
  type        = list(string)
  default     = []
}

variable "default_node_pool_node_labels" {
  description = "Node labels to apply to nodes in the default node pool."
  type        = map(string)
  default     = {}
}

variable "default_node_pool_node_auto_scaling_enabled" {
  description = "Whether to enable cluster autoscaler for the default node pool."
  type        = bool
}

variable "default_node_pool_node_host_encryption_enabled" {
  description = "Whether to enable host encryption for the default node pool nodes."
  type        = bool
}

variable "default_node_pool_node_node_public_ip_enabled" {
  description = "Whether to enable public IP assignment to nodes in the default node pool."
  type        = bool
}

variable "default_node_pool_node_max_pods" {
  description = "Maximum number of pods per node in the default node pool."
  type        = number
}

variable "default_node_pool_node_max_count" {
  description = "Maximum node count for the default node pool (for autoscaling)."
  type        = number
}

variable "default_node_pool_node_min_count" {
  description = "Minimum node count for the default node pool (for autoscaling)."
  type        = number
}

variable "default_node_pool_node_count" {
  description = "Fixed node count for the default node pool (when autoscaling is disabled)."
  type        = number
}

variable "default_node_pool_node" {
  description = "OS disk type for nodes in the default node pool (e.g., Managed, Ephemeral, Premium_LRS)."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the Linux profile on AKS nodes."
  type        = string
}

variable "ssh_key" {
  description = "SSH public key for the admin user on AKS nodes."
  type        = string
}

variable "network_dns_service_ip" {
  description = "IP address for the AKS DNS service."
  type        = string
}

variable "network_plugin" {
  description = "Network plugin to use for AKS (e.g., azure, kubenet)."
  type        = string
}

variable "outbound_type" {
  description = "Outbound type for AKS (e.g., loadBalancer, userDefinedRouting)."
  type        = string
  default     = "userDefinedRouting"

  validation {
    condition     = contains(["loadBalancer", "userDefinedRouting"], var.outbound_type)
    error_message = "The outbound is not valid, it should be: loadbalancer or userDefinedRouting"
  }
}

variable "network_service_cidr" {
  description = "CIDR range for the AKS service network."
  type        = string
}

variable "oms_agent" {
  description = "Optional per-cluster OMS/Log Analytics configuration. If log_analytics_workspace_id is null here, the top-level log_analytics_workspace_id variable is used."
  type = object({
    enabled                    = bool
    log_analytics_workspace_id = string
  })
  default = {
    enabled                    = false
    log_analytics_workspace_id = null
  }
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace used for AKS monitoring and diagnostics."
  type        = string
}

variable "ingress_application_gateway" {
  description = "Optional configuration for integrating AKS with Application Gateway Ingress Controller (AGIC). If gateway_id is null, AGIC integration is disabled."
  type = object({
    enabled      = bool
    gateway_id   = string
    gateway_name = string
    subnet_cidr  = string
    subnet_id    = string
  })
  default = {
    enabled      = false
    gateway_id   = null
    gateway_name = null
    subnet_cidr  = null
    subnet_id    = null
  }
}

variable "tenant_id" {
  description = "Azure AD tenant ID used for AKS AAD integration."
  type        = string
}

variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs that will have admin access to the AKS cluster."
  type        = list(string)
}

variable "azure_rbac_enabled" {
  description = "Whether to enable Azure RBAC for AKS cluster authorization."
  type        = bool
}

variable "keda_enabled" {
  description = "Whether to enable KEDA workload autoscaler profile."
  type        = bool
}

variable "vertical_pod_autoscaler_enabled" {
  description = "Whether to enable vertical pod autoscaler profile."
  type        = bool
}

variable "storage_account_id" {
  description = "Optional storage account ID for diagnostic settings. If null, diagnostics will not be sent to a storage account."
  type        = string
  default     = null
}
