output "vault_id" {
  description = "The ID of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.main.id
}

output "vault_name" {
  description = "The name of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.main.name
}

output "policy_id" {
  description = "The ID of the backup policy"
  value       = azurerm_backup_policy_vm.main.id
}
