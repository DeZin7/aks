# Azure Bastion Terraform Module 🛡️

This module provisions an **Azure Bastion Host** using **OpenTofu / Terraform**, enabling secure access to Azure VMs **without exposing SSH/RDP to the public internet**.

It supports:

- ✅ Deploying Bastion into an **existing VNet + Subnet** (typically `AzureBastionSubnet`)
- ✅ Optional **Resource Group creation**
- ✅ Public IP flexibility:
  - ✅ **Create** a Public IP **or**
  - ✅ **Use an existing** Public IP by ID
- ✅ Optional overrides for **resource group name** and **location** for both the Public IP and Bastion

---

## 🧱 What This Module Does

### Creates (resources)
- `azurerm_bastion_host` ✅ *(always created)*
- `azurerm_resource_group` ✅ *(only if `create_resource_group = true`)*
- `azurerm_public_ip` ✅ *(only if `create_publicip = true`)*

### Reads (data sources)
- `azurerm_virtual_network` (always)
- `azurerm_subnet` (always)
- `azurerm_resource_group` *(only if `create_resource_group = false`)*

---

## 🧠 How Public IP selection works

The module selects the Public IP used by Bastion like this:

```hcl
local.bastion_publicip_id = coalesce(
  var.public_ip_address_id,
  try(azurerm_public_ip.this[0].id, null)
)
```

Meaning:

1. If you provide `public_ip_address_id` ✅ → Bastion uses that
2. Otherwise, if `create_publicip = true` ✅ → Bastion uses the created Public IP
3. If neither is true ❌ → Bastion creation will fail (Azure requires a Public IP)

---

## ⚠️ Important Notes

### ✅ Bastion subnet requirement
Azure Bastion must be deployed into a dedicated subnet named:

- `AzureBastionSubnet`

This subnet must already exist. This module **does not create the subnet**—it only looks it up.

### ✅ Resource group & location defaults
If you do not provide explicit RG/location overrides for the Public IP or Bastion, the module will default to the **created** RG (when `create_resource_group = true`).

> If `create_resource_group = false`, you should provide the RG/location override variables (see inputs), because the locals currently default from the created RG only.

---

## 🚀 Usage

### ✅ Option A: Create RG + Create Public IP + Create Bastion
```hcl
module "bastion" {
  source = "./modules/bastion"

  create_resource_group = true
  rg_name               = "rg-network-dev"
  rg_location           = "eastus2"

  vnet_name = "vnet-dev"
  vnet_rg   = "rg-network-dev"

  subnet_name = "AzureBastionSubnet"
  subnet_rg   = "rg-network-dev"

  create_publicip        = true
  public_ip_address_name = "pip-bastion-dev"
  public_ip_sku          = "Standard"

  # Optional overrides (these can be omitted when RG is created)
  public_ip_location = "eastus2"
  public_ip_rg_name  = "rg-network-dev"
  bastion_location   = "eastus2"
  bastion_rg_name    = "rg-network-dev"

  bastion_host_name = "bastion-dev"
}
```

### ✅ Option B: Use existing Public IP + Create Bastion
```hcl
module "bastion" {
  source = "./modules/bastion"

  # Using an existing RG (module will not create it)
  create_resource_group = false
  rg_name               = "rg-network-shared"
  rg_location           = "eastus2" # only used if create_resource_group=true

  vnet_name = "vnet-shared"
  vnet_rg   = "rg-network-shared"

  subnet_name = "AzureBastionSubnet"
  subnet_rg   = "rg-network-shared"

  # Do NOT create a public ip
  create_publicip = false

  # Provide existing Public IP ID
  public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network-shared/providers/Microsoft.Network/publicIPAddresses/pip-bastion-shared"

  # Provide RG/location overrides (recommended when create_resource_group=false)
  bastion_location = "eastus2"
  bastion_rg_name  = "rg-network-shared"

  bastion_host_name = "bastion-shared"
}
```

---

## 📥 Inputs

### Core

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `create_resource_group` | `bool` | `false` | no | Whether to create the resource group. |
| `rg_name` | `string` | n/a | yes | Resource group name to create/use. |
| `rg_location` | `string` | n/a | yes | Resource group location (only used when `create_resource_group = true`). |
| `vnet_name` | `string` | n/a | yes | Existing Virtual Network name. |
| `vnet_rg` | `string` | n/a | yes | Resource group where the VNet exists. |
| `subnet_name` | `string` | n/a | yes | Existing subnet name (usually `AzureBastionSubnet`). |
| `subnet_rg` | `string` | n/a | yes | Resource group where the subnet exists. |
| `bastion_host_name` | `string` | n/a | yes | Name of the Bastion Host. |

### Public IP options

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `create_publicip` | `bool` | `false` | no | Whether to create a Public IP. |
| `public_ip_address_name` | `string` | n/a | yes* | Name of the Public IP resource (required if `create_publicip = true`). |
| `public_ip_address_id` | `string` | n/a | yes* | Existing Public IP ID (required if `create_publicip = false`). |
| `public_ip_allocation_method` | `string` | `"Static"` | no | Public IP allocation method (`Static` or `Dynamic`). |
| `public_ip_sku` | `string` | `"Basic"` | no | Public IP SKU (`Basic` or `Standard`). |

\* **Either** `public_ip_address_name` (create) **or** `public_ip_address_id` (existing) must be provided so Bastion has a Public IP.

### Location & RG overrides

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `public_ip_location` | `string` | n/a | yes | Public IP location override. |
| `public_ip_rg_name` | `string` | n/a | yes | Public IP resource group name override. |
| `bastion_location` | `string` | n/a | yes | Bastion location override. |
| `bastion_rg_name` | `string` | n/a | yes | Bastion resource group name override. |
| `bastion_publicip_id` | `string` | n/a | yes | Bastion public IP ID override (not required if using `public_ip_address_id` / create public ip logic). |

---

## 📤 Outputs

> This module’s current code snippet does not include outputs.  
If you want the same outputs as before (subnet id, public ip id/ip/fqdn, etc.), add them back and this README can include them.

---

## 🧩 Provider Requirements

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
```

---

## ✅ Recommended validations (strongly recommended)

To avoid misconfiguration, add validations such as:

- Ensure **either** you create a Public IP **or** you provide an existing one:
  - `create_publicip == true` OR `public_ip_address_id != null`

- Ensure Bastion subnet is correct:
  - `subnet_name == "AzureBastionSubnet"` (optional but helpful)

---

## 🧼 Suggested cleanup (optional)

Your variables include both `bastion_publicip_id` and `public_ip_address_id`, which overlap with the `local.bastion_publicip_id` behavior.

A cleaner interface is:

- Keep: `public_ip_address_id` (existing pip)
- Keep: `create_publicip` + `public_ip_address_name` (create pip)
- Remove: `bastion_publicip_id` (since local already decides)

