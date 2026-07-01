variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the primary subnet"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "List of address prefixes for the primary subnet"
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "dns_servers" {
  description = "Custom DNS servers"
  type        = list(string)
  default     = null
}

variable "subnet_service_endpoints" {
  description = "Service endpoints for the primary subnet"
  type        = list(string)
  default     = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

variable "subnet_delegations" {
  description = "Delegations for the primary subnet"
  type = map(object({
    service_name = string
    actions      = list(string)
  }))
  default = {}
}

variable "additional_subnets" {
  description = "Additional subnets to create"
  type = list(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
