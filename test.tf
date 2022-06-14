# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-${var.rsg_name}"
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.node_address_space
}

# Create a subnets within the virtual network
resource "azurerm_subnet" "app-subnet" {
  name                 = "${var.resource_prefix}-app-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.node_address_prefix
}

# Create Linux Public IP
#resource "azurerm_public_ip" "example_public_ip" {
#  count = var.node_count
#  name  = "${var.resource_prefix}-${format("%02d", count.index)}-PublicIP"
#  #name = "${var.resource_prefix}-PublicIP"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  allocation_method   = var.Environment == "Test" ? "Static" : "Dynamic"
#
#  tags = {
#    environment = "Test"
#  }
#}

# Create Network Interface
resource "azurerm_network_interface" "app_nic" {
  count = var.node_count
  #name = "${var.resource_prefix}-NIC"
  name                = "${var.resource_prefix}appVM-${format("%02d", count.index)}-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = element(azurerm_public_ip.example_public_ip.*.id, count.index)
    #public_ip_address_id = azurerm_public_ip.example_public_ip.id
    #public_ip_address_id = azurerm_public_ip.example_public_ip.id
  }
}

# Creating resource NSG
resource "azurerm_network_security_group" "main_nsg" {

  name                = "${var.resource_prefix}-main-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
  tags = {
    environment = "Test"
  }
}

# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "app-subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app-subnet.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id

}
# Create a 2nd subnets within the virtual network

resource "azurerm_subnet" "db-subnet" {
  name                 = "${var.resource_prefix}-db-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.db_address_prefix
}

# Create DB Network Interface
resource "azurerm_network_interface" "db_nic" {
  name                = "db-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db-subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = element(azurerm_public_ip.example_public_ip.*.id, count.index)
    #public_ip_address_id = azurerm_public_ip.example_public_ip.id
    #public_ip_address_id = azurerm_public_ip.example_public_ip.id
  }
}

# Creating DB NSG
resource "azurerm_network_security_group" "db_nsg" {

  name                = "${var.resource_prefix}-db-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.
  security_rule {
    name                       = "5432"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
  tags = {
    environment = "Test"
  }
}

# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "db-subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.db-subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id

}

# Create DB virtual machine

resource "random_password" "db_password" {
  length           = 8
  special          = true
  override_special = "_%@"
}

resource "azurerm_linux_virtual_machine" "postgres-VM" {
  name                  = "postgres-VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "postgres"
  admin_username                  = "postgres"
  admin_password                  = random_password.db_password.result
  disable_password_authentication = false
}

# Virtual Machine Creation — Linux

#resource "random_password" "app_password" {
#  count            = var.node_count
#  length           = 8
#  special          = true
#  override_special = "_%@"
#}

resource "azurerm_virtual_machine" "app_vm" {
  count = var.node_count
  #for_each = random_password.app_password
  name = "${var.resource_prefix}appVM-${format("%02d", count.index)}"
  #name = "${var.resource_prefix}-VM"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_ids         = [element(azurerm_network_interface.app_nic.*.id, count.index)]
  vm_size                       = "Standard_B2s"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "appVM"
    admin_username = "app"
    admin_password = var.app_pass
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Test"
  }
}