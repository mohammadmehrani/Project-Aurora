output "rg_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "The location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "rg_id" {
  description = "The ID of the created resource group"
  value       = azurerm_resource_group.main.id
}
