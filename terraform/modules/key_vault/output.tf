output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "ssh_private_key_secret_id" {
  description = "The secret ID for the SSH private key"
  value       = azurerm_key_vault_secret.admin_ssh_private_key.id
  sensitive   = true
}

output "ssh_public_key_secret_id" {
  description = "The secret ID for the SSH public key"
  value       = azurerm_key_vault_secret.admin_ssh_public_key.id
  sensitive   = true
}
