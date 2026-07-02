variable "extension_name" {
  description = "The name of the VMSS extension"
  type        = string
}

variable "vmss_id" {
  description = "The ID of the VMSS"
  type        = string
}

variable "extension_publisher" {
  description = "The publisher of the extension"
  type        = string
  default     = "Microsoft.Azure.Extensions"
}

variable "extension_type" {
  description = "The type of the extension"
  type        = string
  default     = "CustomScript"
}

variable "extension_version" {
  description = "The version of the extension"
  type        = string
  default     = "2.1"
}

variable "auto_upgrade_minor_version" {
  description = "Auto-upgrade minor version"
  type        = bool
  default     = true
}

variable "force_update_tag" {
  description = "Force update tag for the extension"
  type        = string
  default     = null
}

variable "settings" {
  description = "The settings for the extension (JSON-serialized map)"
  type        = any
  default     = {}
}

variable "protected_settings" {
  description = "The protected settings for the extension (JSON-serialized map)"
  type        = any
  default     = null
}

variable "provision_after_extensions" {
  description = "Extensions to provision after"
  type        = list(string)
  default     = []
}

variable "script_url" {
  description = "The URL of the script to run"
  type        = string
  default     = null
}

variable "command_to_execute" {
  description = "The command to execute"
  type        = string
  default     = null
}

variable "branch_name" {
  description = "The branch name for the script"
  type        = string
  default     = null
}

variable "install_azure_monitor_agent" {
  description = "Install Azure Monitor Agent on the VMSS"
  type        = bool
  default     = true
}

variable "azure_monitor_agent_version" {
  description = "The version of the Azure Monitor Agent"
  type        = string
  default     = "1.30"
}

variable "install_dependency_agent" {
  description = "Install Dependency Agent on the VMSS"
  type        = bool
  default     = true
}

variable "dependency_agent_version" {
  description = "The version of the Dependency Agent"
  type        = string
  default     = "9.10"
}
