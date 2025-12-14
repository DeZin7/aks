# Azure Virtual Network Module (with Optional Resource Group)

This module provisions a **single Azure Virtual Network (VNet)** and optionally
creates the **Resource Group** it lives in.

It is intentionally minimal and designed to act as a **network foundation**
that other modules (subnets, NSGs, route tables, private endpoints, etc.)
can compose on top of.

---

## What this module does

- Optionally **creates** a Resource Group
- Or **reuses** an existing Resource Group
- Creates **one Virtual Network**
- Exposes the **VNet ID** for downstream modules

---

## What this module does NOT do (by design)

- Create subnets
- Create or associate NSGs
- Manage route tables, NAT gateways, or private endpoints

This keeps the module stable and prevents frequent subnet-level changes from
forcing VNet churn.

---

## Usage

### Reuse an existing Resource Group

```hcl
module "vnet" {
  source = "./modules/azure-vnet"

  create_resource_group = false
  rg_name               = "rg-shared-network"
  rg_location           = "eastus" # required syntactically, ignored logically

  vnet_name          = "vnet-core"
  vnet_address_space = ["10.10.0.0/16"]
  vnet_dns_servers   = []

  tags = {
    createdWith = "Terraform/OpenTofu"
    environment = "dev"
    owner       = "platform"
  }
}
```

### Create the Resource Group

```hcl
module "vnet" {
  source = "./modules/azure-vnet"

  create_resource_group = true
  rg_name               = "rg-app-network"
  rg_location           = "eastus2"

  vnet_name          = "vnet-app"
  vnet_address_space = ["10.20.0.0/16"]
  vnet_dns_servers   = ["10.0.0.4", "10.0.0.5"]

  tags = {
    createdWith = "Terraform/OpenTofu"
    environment = "dev"
  }
}
```

---

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---:|---:|---|
| `create_resource_group` | `bool` | `false` | No | Whether to create or reuse the resource group |
| `rg_name` | `string` | n/a | Yes | Resource group name |
| `rg_location` | `string` | n/a | Yes* | Resource group location (used only if created) |
| `vnet_name` | `string` | n/a | Yes | Virtual Network name |
| `vnet_address_space` | `list(string)` | n/a | Yes | CIDR block(s) for the VNet |
| `vnet_dns_servers` | `list(string)` | n/a | Yes | Custom DNS servers (use `[]` for Azure defaults) |
| `tags` | `map(string)` | see variables | No | Tags applied to all resources |

\* Terraform/OpenTofu cannot express conditional requiredness.
`rg_location` is syntactically required but ignored when
`create_resource_group = false`.

---

## Outputs

| Name | Description |
|---|---|
| `vnet_id` | ID of the created Virtual Network |

---

## Implementation Notes

- Resource group name and location are resolved inline using `coalesce(...)`
  to support both creation and lookup paths.
- DNS servers are optional—passing an empty list inherits Azure defaults.
- This module is safe to reuse across environments (dev/staging/prod).

---

## Recommended Composition

Typical platform layout:

```
modules/
├── vnet/           # this module
├── subnet/         # azurerm_subnet (for_each)
├── nsg/            # NSGs + rules
├── route-table/
└── private-endpoint/
```

This keeps responsibilities clear and modules easy to evolve independently.

---

## Requirements

- Terraform / OpenTofu ≥ 1.x
- Provider: `hashicorp/azurerm`

---