variable "sa_name" {
  description = "The name of the storage account (lowercase letters and numbers only)"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "account_tier" {
  description = "The tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "GRS"
}

variable "account_kind" {
  description = "The kind of storage account (StorageV2, BlobStorage, etc.)"
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "The access tier (Hot or Cool)"
  type        = string
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  description = "Enforce HTTPS-only traffic"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "shared_access_key_enabled" {
  description = "Enable shared access key authentication"
  type        = bool
  default     = true
}

variable "infrastructure_encryption_enabled" {
  description = "Enable infrastructure encryption (double encryption)"
  type        = bool
  default     = true
}

variable "blob_versioning_enabled" {
  description = "Enable blob versioning"
  type        = bool
  default     = true
}

variable "blob_change_feed_enabled" {
  description = "Enable blob change feed"
  type        = bool
  default     = true
}

variable "blob_last_access_time_enabled" {
  description = "Enable last access time tracking"
  type        = bool
  default     = false
}

variable "blob_delete_retention_days" {
  description = "Number of days for blob soft delete retention"
  type        = number
  default     = 30
}

variable "container_delete_retention_days" {
  description = "Number of days for container soft delete retention"
  type        = number
  default     = 30
}

variable "network_default_action" {
  description = "The default action for network rules (Allow or Deny)"
  type        = string
  default     = "Deny"
}

variable "network_ip_rules" {
  description = "List of IP rules for network access"
  type        = list(string)
  default     = []
}

variable "network_subnet_ids" {
  description = "List of subnet IDs for network access"
  type        = list(string)
  default     = []
}

variable "network_bypass" {
  description = "Services to bypass network rules"
  type        = set(string)
  default     = ["AzureServices", "Logging", "Metrics"]
}

variable "identity_type" {
  description = "The type of identity (SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "custom_domain_name" {
  description = "Custom domain name for the storage account"
  type        = string
  default     = null
}

variable "custom_domain_use_subdomain" {
  description = "Use subdomain for custom domain"
  type        = bool
  default     = false
}

variable "static_website_enabled" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}

variable "static_website_index_document" {
  description = "The index document for static website"
  type        = string
  default     = "index.html"
}

variable "static_website_error_document" {
  description = "The error document for static website"
  type        = string
  default     = "404.html"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
