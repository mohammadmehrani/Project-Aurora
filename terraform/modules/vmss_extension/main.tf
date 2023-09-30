resource "azurerm_virtual_machine_scale_set_extension" "sre_demo_vmss_ansible" {
  name                         = var.extension_name
  virtual_machine_scale_set_id = var.vmss_id
  publisher                    = var.extension_publisher
  type                         = var.extension_type
  type_handler_version         = var.extension_version

  settings = jsonencode({
    "fileUris" : [var.script_url],
    "commandToExecute" : var.command_to_execute
  })
}
