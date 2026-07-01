output "bastion_id" {
  description = "The ID of the Bastion host"
  value       = azurerm_bastion_host.main.id
}

output "bastion_hostname" {
  description = "The hostname of the Bastion"
  value       = azurerm_bastion_host.main.dns_name
}

output "bastion_ip" {
  description = "The public IP of the Bastion host"
  value       = azurerm_public_ip.bastion.ip_address
}
