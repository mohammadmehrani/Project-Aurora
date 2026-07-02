resource "azurerm_recovery_services_vault" "main" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vault_sku
  soft_delete_enabled = true

  tags = var.tags
}

resource "azurerm_backup_policy_vm" "main" {
  name                = var.policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  timezone = var.timezone

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.retention_daily_count
  }

  retention_weekly {
    count    = var.retention_weekly_count
    weekdays = var.retention_weekly_weekdays
  }

  retention_monthly {
    count    = var.retention_monthly_count
    weekdays = var.retention_monthly_weekdays
    weeks    = var.retention_monthly_weeks
  }

  retention_yearly {
    count    = var.retention_yearly_count
    weekdays = var.retention_yearly_weekdays
    weeks    = var.retention_yearly_weeks
    months   = var.retention_yearly_months
  }
}

resource "azurerm_backup_protected_vm" "main" {
  count               = var.vm_ids != null ? length(var.vm_ids) : 0
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  source_vm_id        = var.vm_ids[count.index]
  backup_policy_id    = azurerm_backup_policy_vm.main.id
}
