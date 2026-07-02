output "extension_name" {
  description = "The name of the VMSS extension"
  value       = azurerm_virtual_machine_scale_set_extension.ansible.name
}

output "extension_id" {
  description = "The ID of the VMSS extension"
  value       = azurerm_virtual_machine_scale_set_extension.ansible.id
}
