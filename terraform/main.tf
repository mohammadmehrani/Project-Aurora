# ============================================================================
# Resource Group
# ============================================================================

module "resource_group" {
  source   = "./modules/resource_group"
  name     = "Project-Aurora-${var.environment}-rg"
  location = var.location
  tags     = local.common_tags
}

# ============================================================================
# Virtual Network with multiple subnets
# ============================================================================

module "vnet_and_subnet" {
  source                  = "./modules/vnet_and_subnet"
  vnet_name               = "Project-Aurora-${var.environment}-vnet"
  subnet_name             = "Project-Aurora-${var.environment}-subnet"
  address_space           = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  resource_group_name     = module.resource_group.rg_name
  location                = module.resource_group.location
  tags                    = local.common_tags

  additional_subnets = [
    {
      name             = "AzureBastionSubnet"
      address_prefixes = var.bastion_subnet_prefixes
    }
  ]
}

# ============================================================================
# Network Security Group
# ============================================================================

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = "Project-Aurora-${var.environment}-nsg"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.location
  subnet_id           = module.vnet_and_subnet.subnet_id
  tags                = local.common_tags
}

# ============================================================================
# Storage Account (encrypted, HA, boot diagnostics)
# ============================================================================

resource "random_string" "sa_suffix" {
  length  = 8
  upper   = false
  lower   = true
  number  = true
  special = false
}

module "storage_account" {
  source                            = "./modules/storage_account"
  sa_name                           = "sa${random_string.sa_suffix.result}"
  resource_group_name               = module.resource_group.rg_name
  location                          = module.resource_group.location
  account_replication_type          = "GRS"
  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  infrastructure_encryption_enabled = true
  blob_versioning_enabled           = true
  blob_change_feed_enabled          = true
  blob_delete_retention_days        = 30
  container_delete_retention_days   = 30
  tags                              = local.common_tags
}

# ============================================================================
# Key Vault (secrets management)
# ============================================================================

module "key_vault" {
  source                      = "./modules/key_vault"
  name                        = "kv-project-aurora-${var.environment}-${random_string.sa_suffix.result}"
  location                    = module.resource_group.location
  resource_group_name         = module.resource_group.rg_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enable_rbac_authorization   = true
  network_acls_default_action = "Deny"
  network_acls_bypass         = "AzureServices"

  admin_ssh_private_key = tls_private_key.main.private_key_pem
  admin_ssh_public_key  = tls_private_key.main.public_key_openssh
  admin_password        = var.admin_password != null ? var.admin_password : one(random_password.admin[*].result)

  tags = local.common_tags
}

resource "random_password" "admin" {
  count   = var.admin_password == null ? 1 : 0
  length  = 32
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# ============================================================================
# Public IP & Load Balancer
# ============================================================================

module "lb_and_pip" {
  source               = "./modules/lb_and_pip"
  pip_name             = "Project-Aurora-${var.environment}-lb-pip"
  lb_name              = "Project-Aurora-${var.environment}-lb"
  frontend_config_name = "Project-Aurora-${var.environment}-lb-frontend"
  backend_pool_name    = "Project-Aurora-${var.environment}-lb-backend"
  probe_name           = "Project-Aurora-${var.environment}-lb-health-probe"
  http_rule_name       = "Project-Aurora-${var.environment}-lb-http-rule"
  resource_group_name  = module.resource_group.rg_name
  location             = module.resource_group.location
  tags                 = local.common_tags
}

# ============================================================================
# Virtual Machine Scale Set (Ubuntu 24.04 LTS)
# ============================================================================

module "vmss" {
  source              = "./modules/vmss"
  vmss_name           = "Project-Aurora-${var.environment}-vmss"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.location

  sku_name                        = var.vm_sku
  instance_count                  = var.vm_instance_count
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password != null ? var.admin_password : one(random_password.admin[*].result)
  disable_password_authentication = var.disable_password_authentication
  admin_ssh_public_key            = tls_private_key.main.public_key_openssh

  # Ubuntu 24.04 LTS (Noble Numbat)
  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"
  image_version   = "latest"

  upgrade_mode                = "Automatic"
  overprovision               = false
  platform_fault_domain_count = 2

  # Premium SSD for better performance
  os_disk_storage_account_type = "Premium_LRS"
  os_disk_size_gb              = 64

  # Network configuration
  subnet_id           = module.vnet_and_subnet.subnet_id
  lb_backend_pool_ids = [module.lb_and_pip.backend_pool_id]
  health_probe_id     = module.lb_and_pip.probe_id

  # Boot diagnostics
  boot_diagnostics_storage_uri = module.storage_account.primary_blob_endpoint

  # Automatic scaling
  enable_scale_in         = true
  enable_scale_out        = true
  scale_in_cpu_threshold  = var.scale_in_cpu_threshold
  scale_out_cpu_threshold = var.scale_out_cpu_threshold
  scale_in_maximum        = var.vm_max_instance_count
  scale_out_maximum       = var.vm_max_instance_count

  tags = local.common_tags
}

# ============================================================================
# VMSS Extensions (Ansible + Monitoring Agents)
# ============================================================================

module "vmss_extension" {
  source         = "./modules/vmss_extension"
  extension_name = "ansibleSetup-${var.environment}"
  vmss_id        = module.vmss.vmss_id

  settings = {
    fileUris = [
      "https://raw.githubusercontent.com/mohammadmehrani/Project-Aurora/${var.branch_name}/ansible/setup.sh"
    ]
    commandToExecute = "export BRANCH_NAME='${var.branch_name}' && export ENVIRONMENT='${var.environment}' && bash setup.sh"
  }

  install_azure_monitor_agent = var.enable_monitoring
  install_dependency_agent    = var.enable_monitoring

  depends_on = [module.vmss]
}

# ============================================================================
# Azure Bastion (secure VM access)
# ============================================================================

module "bastion" {
  count  = var.enable_bastion ? 1 : 0
  source = "./modules/bastion"

  bastion_name        = "Project-Aurora-${var.environment}-bastion"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.vnet_and_subnet.vnet_name
  tags                = local.common_tags
}

# ============================================================================
# Monitoring (Log Analytics + Application Insights + Alerts)
# ============================================================================

module "monitoring" {
  count  = var.enable_monitoring ? 1 : 0
  source = "./modules/monitoring"

  workspace_name      = "log-Project-Aurora-${var.environment}"
  app_insights_name   = "appi-Project-Aurora-${var.environment}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  vmss_id             = module.vmss.vmss_id
  alert_email         = var.alert_email
  tags                = local.common_tags
}

# ============================================================================
# Backup (Recovery Services Vault + Backup Policy)
# ============================================================================

module "backup" {
  count  = var.enable_backup ? 1 : 0
  source = "./modules/backup"

  vault_name          = "rsv-Project-Aurora-${var.environment}"
  policy_name         = "Project-Aurora-${var.environment}-backup-policy"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  tags                = local.common_tags
}
