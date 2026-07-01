output "storage_account_id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.main.id
}

output "primary_blob_endpoint" {
  description = "The Primary Blob Endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "primary_web_endpoint" {
  description = "The Primary Web Endpoint"
  value       = azurerm_storage_account.main.primary_web_endpoint
}

output "primary_access_key" {
  description = "The Primary Access Key"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.main.name
}
