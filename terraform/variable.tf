variable "environment" {
  description = "The deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "The Azure region for all resources"
  type        = string
  default     = "UK South"
}

variable "branch_name" {
  description = "The git branch name used for deployment"
  type        = string
}

variable "cost_center" {
  description = "The cost center for resource tracking"
  type        = string
  default     = "engineering"
}

variable "contact_email" {
  description = "The contact email for operations"
  type        = string
  default     = "admin@project-aurora.io"
}

variable "alert_email" {
  description = "The email address for monitoring alerts"
  type        = string
  default     = "alerts@project-aurora.io"
}

variable "admin_username" {
  description = "The admin username for VMs"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The admin password for VMs (if password auth is used)"
  type        = string
  default     = null
  sensitive   = true
}

variable "disable_password_authentication" {
  description = "Disable password authentication on VMs (use SSH keys)"
  type        = bool
  default     = true
}

variable "ssh_key_algorithm" {
  description = "The algorithm for SSH key generation"
  type        = string
  default     = "RSA"
}

variable "vm_sku" {
  description = "The VM SKU for the scale set"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_instance_count" {
  description = "The default number of VM instances"
  type        = number
  default     = 2
}

variable "vm_min_instance_count" {
  description = "The minimum number of VM instances (scale-in floor)"
  type        = number
  default     = 1
}

variable "vm_max_instance_count" {
  description = "The maximum number of VM instances (scale-in ceiling)"
  type        = number
  default     = 10
}

variable "scale_out_cpu_threshold" {
  description = "CPU percentage threshold for scale-out"
  type        = number
  default     = 75
}

variable "scale_in_cpu_threshold" {
  description = "CPU percentage threshold for scale-in"
  type        = number
  default     = 30
}

variable "enable_bastion" {
  description = "Enable Azure Bastion for secure VM access"
  type        = bool
  default     = true
}

variable "enable_backup" {
  description = "Enable Azure Backup for VM protection"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable comprehensive monitoring (Log Analytics, App Insights, Alerts)"
  type        = bool
  default     = true
}

variable "enable_https" {
  description = "Enable HTTPS with self-signed certificate"
  type        = bool
  default     = true
}

variable "vnet_address_space" {
  description = "The address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the primary subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "app_gateway_subnet_prefixes" {
  description = "The address prefixes for the Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.100.0/24"]
}

variable "bastion_subnet_prefixes" {
  description = "The address prefixes for the Azure Bastion subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
  sensitive   = true
}
