variable "bastion_name" {
  description = "The name of the Azure Bastion host"
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

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "bastion_subnet_name" {
  description = "The name of the Bastion subnet"
  type        = string
  default     = "AzureBastionSubnet"
}

variable "bastion_subnet_address_prefixes" {
  description = "The address prefixes for the Bastion subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "bastion_pip_name" {
  description = "The name of the Bastion public IP"
  type        = string
  default     = "bastion-pip"
}

variable "bastion_sku" {
  description = "The SKU of the Bastion host"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
