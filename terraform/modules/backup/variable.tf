variable "vault_name" {
  description = "The name of the Recovery Services Vault"
  type        = string
}

variable "policy_name" {
  description = "The name of the backup policy"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "vm_ids" {
  description = "The IDs of the VMs to protect"
  type        = list(string)
  default     = null
}

variable "vault_sku" {
  description = "The SKU of the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "timezone" {
  description = "The timezone for the backup schedule"
  type        = string
  default     = "UTC"
}

variable "backup_frequency" {
  description = "The frequency of backups"
  type        = string
  default     = "Daily"
}

variable "backup_time" {
  description = "The time of day for backups (24-hour format)"
  type        = string
  default     = "23:00"
}

variable "retention_daily_count" {
  description = "The number of daily retention points"
  type        = number
  default     = 30
}

variable "retention_weekly_count" {
  description = "The number of weekly retention points"
  type        = number
  default     = 12
}

variable "retention_weekly_weekdays" {
  description = "The weekdays for weekly retention"
  type        = set(string)
  default     = ["Sunday"]
}

variable "retention_monthly_count" {
  description = "The number of monthly retention points"
  type        = number
  default     = 12
}

variable "retention_monthly_weekdays" {
  description = "The weekdays for monthly retention"
  type        = set(string)
  default     = ["Sunday"]
}

variable "retention_monthly_weeks" {
  description = "The weeks for monthly retention"
  type        = set(string)
  default     = ["First"]
}

variable "retention_yearly_count" {
  description = "The number of yearly retention points"
  type        = number
  default     = 5
}

variable "retention_yearly_weekdays" {
  description = "The weekdays for yearly retention"
  type        = set(string)
  default     = ["Sunday"]
}

variable "retention_yearly_weeks" {
  description = "The weeks for yearly retention"
  type        = set(string)
  default     = ["First"]
}

variable "retention_yearly_months" {
  description = "The months for yearly retention"
  type        = set(string)
  default     = ["January"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
