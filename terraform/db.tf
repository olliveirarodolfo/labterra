
# Create a resource group for DB Resource
resource "azurerm_resource_group" "rgdb" {
  name     = var.db-rg-name
  location = var.apps-location

  tags = {   
     COSTCENTER  = "INFRA"
     DEPT        = "DATABASE"
     ENV         = "PRD"
   }
}

# Create network interface for DB VM
resource "azurerm_network_interface" "nicdbvm" {
    
  name                = var.db_vm_network_interface_name
  location            = azurerm_resource_group.rgdb.location
  resource_group_name = azurerm_resource_group.rgdb.name

  ip_configuration {
    name                          = "${var.db_vm_virtual_machine_name}-IpConfig"
    subnet_id                     = azurerm_subnet.db-subnet.id
    private_ip_address_allocation = "Dynamic"
    }

    depends_on = [
      azurerm_subnet.app-subnet
  ]

}

# Create DB VM virtual machine
resource "azurerm_virtual_machine" "dbvm" {
  name                  = var.db_vm_virtual_machine_name
  location              = azurerm_resource_group.rgdb.location
  resource_group_name   = azurerm_resource_group.rgdb.name
  network_interface_ids = [azurerm_network_interface.nicdbvm.id]
  vm_size                  = "Standard_DS1_v2"

# Zone Information
  zones = [1]

  storage_os_disk {
    name                 = "${var.db_vm_virtual_machine_name}-OsDisk"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Premium_LRS"
  }
   
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

# operational system parameters
  
  os_profile {
    computer_name                   = var.db_vm_virtual_machine_name
    admin_username                  = var.vm_admin_user
    admin_password                  = random_string.password_string.result
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = [
    azurerm_resource_group.rgdb, azurerm_network_interface.nicdbvm
  ]
 
}
# Script extesion to config DB VM
resource "azurerm_virtual_machine_extension" "dbextension" {
  name                 = "appconfigscript"
  virtual_machine_id   = azurerm_virtual_machine.dbvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl -sL https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/dbvm/dbvm.sh | bash -"
    }
SETTINGS
depends_on = [
    azurerm_virtual_machine.dbvm
  ]

}
