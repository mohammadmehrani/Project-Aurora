locals {
  scale_rules = concat(
    var.enable_scale_out ? ["scale_out"] : [],
    var.enable_scale_in ? ["scale_in"] : []
  )
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                            = var.vmss_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku                             = var.sku_name
  instances                       = var.instance_count
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  upgrade_mode                    = var.upgrade_mode
  health_probe_id                 = var.health_probe_id
  overprovision                   = var.overprovision
  platform_fault_domain_count     = var.platform_fault_domain_count
  zone_balance                    = var.zone_balance
  zones                           = var.zones
  source_image_id                 = var.source_image_id
  custom_data                     = var.custom_data
  user_data                       = var.user_data
  tags                            = var.tags

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication && var.admin_ssh_public_key != "" ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_public_key
    }
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  network_interface {
    name    = var.network_interface_name
    primary = true

    ip_configuration {
      name      = var.ip_configuration_name
      primary   = true
      subnet_id = var.subnet_id

      dynamic "public_ip_address" {
        for_each = var.enable_public_ip ? [1] : []
        content {
          name                = "${var.vmss_name}-pip"
          domain_name_label   = var.public_ip_domain_label
          public_ip_prefix_id = var.public_ip_prefix_id
          version             = var.public_ip_version
        }
      }

      load_balancer_backend_address_pool_ids = var.lb_backend_pool_ids
    }

    dynamic "ip_configuration" {
      for_each = var.additional_ip_configurations
      content {
        name      = ip_configuration.value.name
        primary   = false
        subnet_id = ip_configuration.value.subnet_id
      }
    }
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  dynamic "extension" {
    for_each = var.extensions
    content {
      name                       = extension.value.name
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      auto_upgrade_minor_version = try(extension.value.auto_upgrade_minor_version, true)
      settings                   = try(extension.value.settings, null)
      protected_settings         = try(extension.value.protected_settings, null)
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "main" {
  name                = "${var.vmss_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.main.id
  enabled             = length(local.scale_rules) > 0

  profile {
    name = "AutoScale Profile"

    capacity {
      default = var.instance_count
      minimum = var.scale_in_minimum
      maximum = var.scale_out_maximum
    }

    dynamic "rule" {
      for_each = local.scale_rules

      content {
        metric_trigger {
          metric_name        = "Percentage CPU"
          metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
          time_grain         = "PT1M"
          statistic          = "Average"
          time_window        = rule.value == "scale_out" ? var.scale_out_window : "PT10M"
          time_aggregation   = "Average"
          operator           = rule.value == "scale_out" ? "GreaterThan" : "LessThan"
          threshold          = rule.value == "scale_out" ? var.scale_out_cpu_threshold : var.scale_in_cpu_threshold
        }

        scale_action {
          direction = rule.value == "scale_out" ? "Increase" : "Decrease"
          type      = "ChangeCount"
          value     = rule.value == "scale_out" ? var.scale_out_count : var.scale_in_count
          cooldown  = rule.value == "scale_out" ? var.scale_out_cooldown : var.scale_in_cooldown
        }
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
    }
  }

  tags = var.tags
}
