resource "azurerm_public_ip" "main" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.lb_sku
  domain_name_label   = var.pip_domain_name_label
  idle_timeout_in_minutes = var.pip_idle_timeout
  ip_version          = var.pip_ip_version
  tags                = var.tags
}

resource "azurerm_lb" "main" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.lb_sku
  sku_tier            = var.lb_sku_tier
  tags                = var.tags

  frontend_ip_configuration {
    name                 = var.frontend_config_name
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "main" {
  name                = var.probe_name
  loadbalancer_id     = azurerm_lb.main.id
  port                = var.probe_port
  protocol            = var.probe_protocol
  request_path        = var.probe_request_path
  interval_in_seconds = var.probe_interval
  number_of_probes    = var.probe_count
}

resource "azurerm_lb_rule" "http" {
  name                           = var.http_rule_name
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = var.http_rule_protocol
  frontend_port                  = var.http_rule_frontend_port
  backend_port                   = var.http_rule_backend_port
  frontend_ip_configuration_name = var.frontend_config_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.main.id
  enable_floating_ip             = var.http_rule_enable_floating_ip
  idle_timeout_in_minutes        = var.http_rule_idle_timeout
  load_distribution              = var.http_rule_load_distribution
  disable_outbound_snat          = var.http_rule_disable_outbound_snat
}

resource "azurerm_lb_outbound_rule" "main" {
  count = var.enable_outbound_rule ? 1 : 0

  name                    = var.outbound_rule_name
  loadbalancer_id         = azurerm_lb.main.id
  protocol                = var.outbound_rule_protocol
  allocated_outbound_ports = var.outbound_rule_ports

  frontend_ip_configuration {
    name = var.frontend_config_name
  }

  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}
