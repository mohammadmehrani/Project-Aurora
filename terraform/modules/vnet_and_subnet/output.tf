output "subnet_id" {
  description = "The ID of the primary subnet"
  value       = azurerm_subnet.main.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_name" {
  description = "The name of the primary subnet"
  value       = azurerm_subnet.main.name
}

output "additional_subnet_ids" {
  description = "The IDs of any additional subnets"
  value       = azurerm_subnet.additional[*].id
}

output "additional_subnet_names" {
  description = "The names of any additional subnets"
  value       = azurerm_subnet.additional[*].name
}
