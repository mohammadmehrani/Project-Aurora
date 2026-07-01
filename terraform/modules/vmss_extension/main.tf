resource "azurerm_virtual_machine_scale_set_extension" "ansible" {
  name                         = var.extension_name
  virtual_machine_scale_set_id = var.vmss_id
  publisher                    = var.extension_publisher
  type                         = var.extension_type
  type_handler_version         = var.extension_version
  auto_upgrade_minor_version   = var.auto_upgrade_minor_version
  force_update_tag             = var.force_update_tag

  settings = jsonencode(var.settings)

  protected_settings = var.protected_settings != null ? jsonencode(var.protected_settings) : null

  provision_after_extensions = var.provision_after_extensions
}

resource "azurerm_virtual_machine_scale_set_extension" "azure_monitor" {
  count = var.install_azure_monitor_agent ? 1 : 0

  name                         = "${var.extension_name}-azure-monitor"
  virtual_machine_scale_set_id = var.vmss_id
  publisher                    = "Microsoft.Azure.Monitor"
  type                         = "AzureMonitorLinuxAgent"
  type_handler_version         = var.azure_monitor_agent_version
  auto_upgrade_minor_version   = true

  settings = jsonencode({
    authentication = {
      managedIdentity = {
        identifier-name  = "mi_res_id"
        identifier-value = ""
      }
    }
  })

  depends_on = [azurerm_virtual_machine_scale_set_extension.ansible]
}

resource "azurerm_virtual_machine_scale_set_extension" "dependency_agent" {
  count = var.install_dependency_agent ? 1 : 0

  name                         = "${var.extension_name}-dependency-agent"
  virtual_machine_scale_set_id = var.vmss_id
  publisher                    = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                         = "DependencyAgentLinux"
  type_handler_version         = var.dependency_agent_version
  auto_upgrade_minor_version   = true

  depends_on = var.install_azure_monitor_agent ? [azurerm_virtual_machine_scale_set_extension.azure_monitor[0]] : [azurerm_virtual_machine_scale_set_extension.ansible]
}
