output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.rg_name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = module.resource_group.location
}

output "load_balancer_public_ip" {
  description = "The public IP address of the load balancer"
  value       = module.lb_and_pip.public_ip_address
}

output "load_balancer_fqdn" {
  description = "The FQDN of the load balancer"
  value       = module.lb_and_pip.public_ip_fqdn
}

output "vmss_name" {
  description = "The name of the VM scale set"
  value       = module.vmss.vmss_name
}

output "vmss_id" {
  description = "The ID of the VM scale set"
  value       = module.vmss.vmss_id
}

output "application_url" {
  description = "The URL to access the application"
  value       = "http://${module.lb_and_pip.public_ip_address}"
}

output "bastion_hostname" {
  description = "The hostname of the Azure Bastion host"
  value       = var.enable_bastion ? module.bastion[0].bastion_hostname : null
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
  sensitive   = true
}

output "app_insights_instrumentation_key" {
  description = "The instrumentation key for Application Insights"
  value       = var.enable_monitoring ? module.monitoring[0].app_insights_instrumentation_key : null
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "The connection string for Application Insights"
  value       = var.enable_monitoring ? module.monitoring[0].app_insights_connection_string : null
  sensitive   = true
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage_account.storage_account_name
}

output "recovery_vault_name" {
  description = "The name of the Recovery Services Vault"
  value       = var.enable_backup ? module.backup[0].vault_name : null
}

output "environment" {
  description = "The deployment environment"
  value       = var.environment
}
