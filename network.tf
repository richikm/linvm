resource "azurerm_virtual_network" "tfvnet"{
    name = "tfvnet-network"
    address_space = var.address_space
    location = azurerm_resource_group.RGTerra.location
    resource_group_name = azurerm_resource_group.RGTerra.name
}

resource "azurerm_subnet" "tfsubnet"{
    name = "tfsubnet"
    address_prefix = var.address_prefix
    virtual_network_name = azurerm_virtual_network.tfvnet.name
    resource_group_name = azurerm_resource_group.RGTerra.name
}
resource "azurerm_network_interface" "tfnic"{
    name = "tfnic"
    location = azurerm_resource_group.RGTerra.location
    resource_group_name = azurerm_resource_group.RGTerra.name
    
    ip_configuration {
        name = "private-ip"
        subnet_id = azurerm_subnet.tfsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.tfpubip.id
    }
}   
resource "azurerm_public_ip" "tfpubip"{
  name                = "tfpubip"
  resource_group_name = azurerm_resource_group.RGTerra.name
  location            = azurerm_resource_group.RGTerra.location
  allocation_method   = "Dynamic"
  domain_name_label   = "richikazureip2345"

}

resource "azurerm_network_security_group" "tfnsg"{
    name = "tfnsg"
    resource_group_name = azurerm_resource_group.RGTerra.name
    location            = azurerm_resource_group.RGTerra.location

    security_rule {
    name                       = "inbound_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound_HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_map" {
  network_interface_id      = azurerm_network_interface.tfnic.id
  network_security_group_id = azurerm_network_security_group.tfnsg.id
}