variable "nsg_name" {
  description = "The name of the network security group"
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

variable "subnet_id" {
  description = "The ID of the subnet to associate with the NSG"
  type        = string
}

variable "allowed_http_sources" {
  description = "List of source IP prefixes allowed for HTTP"
  type        = list(string)
  default     = ["*"]
}

variable "allowed_https_sources" {
  description = "List of source IP prefixes allowed for HTTPS"
  type        = list(string)
  default     = ["*"]
}

variable "create_app_gateway_nsg" {
  description = "Create additional NSG for Application Gateway subnet"
  type        = bool
  default     = false
}

variable "app_gateway_subnet_id" {
  description = "The ID of the Application Gateway subnet"
  type        = string
  default     = null
}

variable "app_gateway_source_prefixes" {
  description = "Source IP prefixes for Application Gateway"
  type        = list(string)
  default     = ["*"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
