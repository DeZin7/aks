variable "rg_name" {
  description = "The Resource Group name."
  type        = string
}

variable "storage_account_name" {
  description = "The storage account name."
  type        = string
}

variable "storage_account_tier" {
  description = "The storage account tier."
  type        = string
}

variable "storage_account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa. "
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "storage_account_replication_type is required and should be one of these: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  }
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account"
  type        = string
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts."
  type        = string
}

variable "https_traffic_only_enabled" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information."
  type        = bool
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account."
  type        = string
}

variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key."
  type        = bool
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled?"
  type        = bool
}

variable "default_to_oauth_authentication" {
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account."
  type        = bool
}

variable "network_rules_default_action" {
  description = " (Required) Specifies the default action of allow or deny when no other rules match."
  type        = string
}

variable "network_rules_ip_rules" {
  description = " (Optional) List of public IP or IP ranges in CIDR Format. Only IPv4 addresses are allowed."
  type        = list(string)
}

variable "network_rules_subnet_id" {
  description = "(Optional) A list of resource ids for subnets."
  type        = list(string)
}

variable "tags" {
  description = "The resource tags."
  type        = map(string)
}