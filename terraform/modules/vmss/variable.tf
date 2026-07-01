variable "vmss_name" {
  description = "The name of the VM scale set"
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

variable "sku_name" {
  description = "The SKU of the VMs (e.g. Standard_B2s)"
  type        = string
  default     = "Standard_B2s"
}

variable "instance_count" {
  description = "The number of VM instances"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "The admin username"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The admin password (if password auth is enabled)"
  type        = string
  default     = null
  sensitive   = true
}

variable "disable_password_authentication" {
  description = "Disable password authentication (use SSH keys)"
  type        = bool
  default     = true
}

variable "admin_ssh_public_key" {
  description = "The SSH public key for admin access"
  type        = string
  default     = ""
}

variable "upgrade_mode" {
  description = "The upgrade mode (Automatic, Rolling, Manual)"
  type        = string
  default     = "Automatic"
}

variable "health_probe_id" {
  description = "The ID of the load balancer health probe"
  type        = string
  default     = null
}

variable "overprovision" {
  description = "Enable overprovisioning"
  type        = bool
  default     = false
}

variable "platform_fault_domain_count" {
  description = "The number of fault domains"
  type        = number
  default     = 2
}

variable "zone_balance" {
  description = "Balance VMs across availability zones"
  type        = bool
  default     = false
}

variable "zones" {
  description = "A list of availability zones"
  type        = list(string)
  default     = null
}

variable "source_image_id" {
  description = "The ID of a custom image"
  type        = string
  default     = null
}

variable "custom_data" {
  description = "Custom data to pass to the VM"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data to pass to the VM"
  type        = string
  default     = null
}

variable "image_publisher" {
  description = "The publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the VM image"
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "image_sku" {
  description = "The SKU of the VM image"
  type        = string
  default     = "server"
}

variable "image_version" {
  description = "The version of the VM image"
  type        = string
  default     = "latest"
}

variable "os_disk_caching" {
  description = "The caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in GB"
  type        = number
  default     = 64
}

variable "plan_name" {
  description = "The plan name for marketplace images"
  type        = string
  default     = null
}

variable "plan_publisher" {
  description = "The plan publisher"
  type        = string
  default     = null
}

variable "plan_product" {
  description = "The plan product"
  type        = string
  default     = null
}

variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
  default     = "default"
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration"
  type        = string
  default     = "primary"
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "enable_public_ip" {
  description = "Enable public IP for each VM instance"
  type        = bool
  default     = false
}

variable "public_ip_domain_label" {
  description = "The domain name label for the public IP"
  type        = string
  default     = null
}

variable "public_ip_prefix_id" {
  description = "The ID of the public IP prefix"
  type        = string
  default     = null
}

variable "public_ip_version" {
  description = "The IP version for the public IP"
  type        = string
  default     = "IPv4"
}

variable "lb_backend_pool_ids" {
  description = "The IDs of the load balancer backend pools"
  type        = list(string)
  default     = []
}

variable "additional_ip_configurations" {
  description = "Additional IP configurations"
  type = list(object({
    name      = string
    subnet_id = string
  }))
  default = []
}

variable "boot_diagnostics_storage_uri" {
  description = "The storage URI for boot diagnostics"
  type        = string
  default     = null
}

variable "extensions" {
  description = "A list of extensions to install on the VMSS"
  type = list(object({
    name                       = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    auto_upgrade_minor_version = optional(bool, true)
    settings                   = optional(string)
    protected_settings         = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_scale_in" {
  description = "Enable the scale-in autoscale rule"
  type        = bool
  default     = true
}

variable "enable_scale_out" {
  description = "Enable the scale-out autoscale rule"
  type        = bool
  default     = true
}

variable "scale_in_minimum" {
  description = "The minimum instance count for scale-in"
  type        = number
  default     = 1
}

variable "scale_in_maximum" {
  description = "The maximum instance count for scale-in profile"
  type        = number
  default     = 10
}

variable "scale_in_cpu_threshold" {
  description = "The CPU threshold to trigger scale-in"
  type        = number
  default     = 30
}

variable "scale_in_count" {
  description = "The number of instances to scale in"
  type        = string
  default     = "-1"
}

variable "scale_in_cooldown" {
  description = "The cooldown period after a scale-in action"
  type        = string
  default     = "PT10M"
}

variable "scale_out_minimum" {
  description = "The minimum instance count for scale-out profile"
  type        = number
  default     = 1
}

variable "scale_out_maximum" {
  description = "The maximum instance count for scale-out"
  type        = number
  default     = 10
}

variable "scale_out_cpu_threshold" {
  description = "The CPU threshold to trigger scale-out"
  type        = number
  default     = 75
}

variable "scale_out_count" {
  description = "The number of instances to scale out"
  type        = string
  default     = "1"
}

variable "scale_out_cooldown" {
  description = "The cooldown period after a scale-out action"
  type        = string
  default     = "PT5M"
}

variable "scale_out_window" {
  description = "The time window for scale-out metric evaluation"
  type        = string
  default     = "PT5M"
}
