variable "workspace_name" {
  description = "The name of the Log Analytics Workspace"
  type        = string
}

variable "app_insights_name" {
  description = "The name of the Application Insights instance"
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

variable "vmss_id" {
  description = "The ID of the VMSS to monitor"
  type        = string
}

variable "workspace_sku" {
  description = "The SKU of the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "workspace_retention_in_days" {
  description = "The retention period in days"
  type        = number
  default     = 30
}

variable "app_insights_type" {
  description = "The application type for Application Insights"
  type        = string
  default     = "web"
}

variable "alert_email" {
  description = "The email address for alerts"
  type        = string
}

variable "action_group_short_name" {
  description = "The short name for the action group"
  type        = string
  default     = "AuroraAlert"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
