resource "azurerm_key_vault" "main" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled
  enable_rbac_authorization  = var.enable_rbac_authorization

  network_acls {
    default_action = var.network_acls_default_action
    bypass         = var.network_acls_bypass
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "admin_ssh_private_key" {
  name         = "admin-ssh-private-key"
  value        = var.admin_ssh_private_key
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "admin_ssh_public_key" {
  name         = "admin-ssh-public-key"
  value        = var.admin_ssh_public_key
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}
