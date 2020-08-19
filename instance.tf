resource "azurerm_linux_virtual_machine" "tflinvm"{
  name = "tflinvm"  
  resource_group_name = azurerm_resource_group.RGTerra.name
  location            = azurerm_resource_group.RGTerra.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  #admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.tfnic.id]
  custom_data           = base64encode("#!/bin/bash\n\napt-get update && apt-get install -y nginx && systemctl enable nginx && systemctl start nginx")
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./mykey.pub.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

/* data "azurerm_public_ip" "tfpubip" {
  name = azurerm_public_ip.tfpubip.name
  resource_group_name = azurerm_linux_virtual_machine.tflinvm.resource_group_name
} */
output "Public_ip_address" {
  value = azurerm_linux_virtual_machine.tflinvm.public_ip_address
}

output "FQDN" {
  value = azurerm_public_ip.tfpubip.fqdn
}