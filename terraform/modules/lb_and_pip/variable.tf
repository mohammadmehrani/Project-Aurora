variable "pip_name" {
  description = "The name of the public IP"
  type        = string
}

variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "frontend_config_name" {
  description = "The name of the frontend configuration"
  type        = string
}

variable "backend_pool_name" {
  description = "The name of the backend pool"
  type        = string
}

variable "probe_name" {
  description = "The name of the health probe"
  type        = string
}

variable "http_rule_name" {
  description = "The name of the HTTP load balancer rule"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "pip_allocation_method" {
  description = "The allocation method (Static or Dynamic)"
  type        = string
  default     = "Static"
}

variable "pip_domain_name_label" {
  description = "The domain name label for the public IP"
  type        = string
  default     = null
}

variable "pip_idle_timeout" {
  description = "The idle timeout in minutes"
  type        = number
  default     = 4
}

variable "pip_ip_version" {
  description = "The IP version (IPv4 or IPv6)"
  type        = string
  default     = "IPv4"
}

variable "lb_sku" {
  description = "The SKU of the load balancer (Basic or Standard)"
  type        = string
  default     = "Standard"
}

variable "lb_sku_tier" {
  description = "The SKU tier of the load balancer (Regional or Global)"
  type        = string
  default     = "Regional"
}

variable "probe_port" {
  description = "The port for the health probe"
  type        = number
  default     = 80
}

variable "probe_protocol" {
  description = "The protocol for the health probe"
  type        = string
  default     = "Http"
}

variable "probe_request_path" {
  description = "The request path for the health probe"
  type        = string
  default     = "/health"
}

variable "probe_interval" {
  description = "The interval in seconds between probes"
  type        = number
  default     = 5
}

variable "probe_count" {
  description = "The number of failed probes before marking as unhealthy"
  type        = number
  default     = 2
}

variable "http_rule_protocol" {
  description = "The protocol for the HTTP rule"
  type        = string
  default     = "Tcp"
}

variable "http_rule_frontend_port" {
  description = "The frontend port"
  type        = number
  default     = 80
}

variable "http_rule_backend_port" {
  description = "The backend port"
  type        = number
  default     = 80
}

variable "http_rule_enable_floating_ip" {
  description = "Enable floating IP"
  type        = bool
  default     = false
}

variable "http_rule_idle_timeout" {
  description = "The idle timeout in minutes"
  type        = number
  default     = 4
}

variable "http_rule_load_distribution" {
  description = "The load distribution type"
  type        = string
  default     = "Default"
}

variable "http_rule_disable_outbound_snat" {
  description = "Disable outbound SNAT"
  type        = bool
  default     = false
}

variable "enable_outbound_rule" {
  description = "Enable outbound rule"
  type        = bool
  default     = false
}

variable "outbound_rule_name" {
  description = "The name of the outbound rule"
  type        = string
  default     = "OutboundRule"
}

variable "outbound_rule_protocol" {
  description = "The protocol for the outbound rule"
  type        = string
  default     = "All"
}

variable "outbound_rule_ports" {
  description = "The number of outbound ports"
  type        = number
  default     = 1024
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
