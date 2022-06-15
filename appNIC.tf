#variable "app_nics_var" {
#  description = "names of apps VM NICs"
#  type = list(string)
#  default = ["app_nic1", "app_nic2", "app_nic3"]
#}
#resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "test" {
#  backend_address_pool_id = "azurerm_lb_backend_address_pool.BP_pool.id"
#  ip_configuration_name   = "azurerm_ip_configuration_name_extIP"
#  network_interface_id    = "[element(azurerm_network_interface.app_nic.*.id, count.index)]"
#}
