variable "location" {
  default = "North Central US"
  type    = string
}

variable "rsg_name" {
  type    = string
  default = "week5-base"
}

variable "resource_prefix" {
  default = "TF"
  type    = string
}

variable "node_address_space" {
  type    = list(string)
  default = ["1.0.0.0/16"]
}

#variable for network range

variable "node_address_prefix" {
  type    = list(string)
  default = ["1.0.0.0/24"]
}
variable "db_address_prefix" {
  type    = list(string)
  default = ["1.0.1.0/24"]
}

variable "app_ip_addresses" {
  default = [
    "10.0.0.4",
    "10.0.0.5",
    "10.0.0.6",
  ]
}

#variable for Environment
variable "Environment" {
  type    = string
  default = "test"
}

variable "node_count" {
  type    = number
  default = "3"
}

#variable "app_NICs" {
#  type    = map(string)
#  default = azurerm_network_interface.app_nic.*.${count.index}
#}



