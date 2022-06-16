resource "azurerm_public_ip" "pub_ip" {
  name                = "vmss-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = random_string.fqdn.result
  #  tags                = var.Environment
}

resource "azurerm_lb" "LB" {
  name                = "vmss-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pub_ip.id
  }

  #  tags = var.Environment
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.LB.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "LB_probe" {
  #  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.LB.id
  name            = "ssh-running-probe"
  port            = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  #  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.LB.id
  name            = "http"
  protocol        = "Tcp"
  frontend_port   = var.application_port
  backend_port    = var.application_port
  #  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.LB_probe.id
}