# Load Balancer configuration and association
resource "azurerm_public_ip" "extIP" {
  name                = "publicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "LB" {
  name = "loadBalancer"
  #lb_sku              = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #subnet_id           = azurerm_subnet.app-subnet.id

  frontend_ip_configuration {
    name                 = "extIP"
    public_ip_address_id = azurerm_public_ip.extIP.id
  }
  depends_on = [azurerm_public_ip.extIP
  ]
}

resource "azurerm_lb_backend_address_pool" "BP_pool" {
  loadbalancer_id = azurerm_lb.LB.id
  name            = "BackEndAddressPool"
  depends_on = [azurerm_lb.LB
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  network_interface_id    = ["${azurerm_network_interface.app_nic.*.id}"]
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.BP_pool.id
}

#resource "azurerm_lb_backend_address_pool_address" "baapa" {
#  count = var.node_count
#  name                    = "baapa"
#  backend_address_pool_id = azurerm_lb_backend_address_pool.BP_pool.id
#  virtual_network_id      = azurerm_virtual_network.vnet.id
#  ip_address              = [element(azurerm_network_interface.app_nic.*.id, count.index)]
#  depends_on = [azurerm_lb_backend_address_pool.BP_pool
#  ]
#}

#resource "azurerm_lb_backend_address_pool_address" "appVM2_address" {
#  name                    = "appVM2"
#  backend_address_pool_id = azurerm_lb_backend_address_pool.BP_pool.id
#  virtual_network_id      = azurerm_virtual_network.vnet.id
#  ip_address              = "${element(var.app_ip_addresses, count.index)}"
#  depends_on = [azurerm_lb_backend_address_pool.BP_pool
#  ]
#}
#
#resource "azurerm_lb_backend_address_pool_address" "appVM3_address" {
#  name                    = "appVM3"
#  backend_address_pool_id = azurerm_lb_backend_address_pool.BP_pool.id
#  virtual_network_id      = azurerm_virtual_network.vnet.id
#  ip_address              = "${element(var.app_ip_addresses, count.index)}"
#  depends_on = [azurerm_lb_backend_address_pool.BP_pool
#  ]
#}

resource "azurerm_lb_probe" "H_Prob" {
  #  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.LB.id
  name            = "prob8080"
  port            = 8080
}

#resource "azurerm_lb_nat_rule" "LB-NATin" {
#  resource_group_name            = azurerm_resource_group.rg.name
#  loadbalancer_id                = azurerm_lb.LB.id
#  name                           = "8080in"
#  protocol                       = "Tcp"
#  frontend_port                  = 8080
#  backend_port                   = 8080
#  frontend_ip_configuration_name = "extIP"
#}

resource "azurerm_lb_rule" "LB_rule" {
  #  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "extIP"
}