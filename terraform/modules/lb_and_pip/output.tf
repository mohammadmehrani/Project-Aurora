output "backend_pool_id" {
  description = "The ID of the backend address pool"
  value       = azurerm_lb_backend_address_pool.main.id
}

output "public_ip_id" {
  description = "The ID of the public IP"
  value       = azurerm_public_ip.main.id
}

output "public_ip_address" {
  description = "The public IP address"
  value       = azurerm_public_ip.main.ip_address
}

output "public_ip_fqdn" {
  description = "The fully qualified domain name of the public IP"
  value       = azurerm_public_ip.main.fqdn
}

output "lb_id" {
  description = "The ID of the load balancer"
  value       = azurerm_lb.main.id
}

output "probe_id" {
  description = "The ID of the health probe"
  value       = azurerm_lb_probe.main.id
}
