variable "name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "sku_name" {
  description = "The SKU of the Key Vault (standard or premium)"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain deleted vaults"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for the Key Vault"
  type        = bool
  default     = true
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for the Key Vault"
  type        = bool
  default     = true
}

variable "network_acls_default_action" {
  description = "The default action for network ACLs"
  type        = string
  default     = "Deny"
}

variable "network_acls_bypass" {
  description = "The bypass option for network ACLs"
  type        = string
  default     = "AzureServices"
}

variable "admin_ssh_private_key" {
  description = "The admin SSH private key"
  type        = string
  sensitive   = true
}

variable "admin_ssh_public_key" {
  description = "The admin SSH public key"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "The admin password for VMs"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
