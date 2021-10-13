# Create a resource group for APP2
resource "azurerm_resource_group" "rg" {
  name     = var.app2-rg-name
  location = var.apps-location

  tags = {   
     COSTCENTER  = "INFRA"
     DEPT        = "APPS"
     ENV         = "PRD"
   }
}
########## APP2 VM1 Configurations ############

# APP2 VM1 network interface

# Create network interface for APP2 VM1
resource "azurerm_network_interface" "nicvm1" {
    
  name                = var.app2_vm1_network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.app2_vm1_virtual_machine_name}-IpConfig"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
    }

    depends_on = [
      azurerm_subnet.app-subnet
  ]

}

# Create APP2 VM1 virtual machine
resource "azurerm_virtual_machine" "linuxvm1" {
  name                  = var.app2_vm1_virtual_machine_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nicvm1.id]
  vm_size                  = "Standard_DS1_v2"

# Zone Information
  zones = [1]

  storage_os_disk {
    name                 = "${var.app2_vm1_virtual_machine_name}-OsDisk"
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
    computer_name                   = var.app2_vm1_virtual_machine_name
    admin_username                  = var.vm_admin_user
    admin_password                  = random_string.password_string.result
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = [
    azurerm_resource_group.rg, azurerm_network_interface.nicvm1
  ]
 
}
# Script extesion to config app2 VM1
resource "azurerm_virtual_machine_extension" "vm1extension" {
  name                 = "appconfigscript"
  virtual_machine_id   = azurerm_virtual_machine.linuxvm1.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl -sL https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/app2.sh | bash -"
    }
SETTINGS
depends_on = [
    azurerm_virtual_machine.linuxvm1
  ]

}

##################### APP2 VM2 Configurations ################

# APP2 VM2 network interface

# Create network interface for APP2 VM2
resource "azurerm_network_interface" "nicvm2" {
    
  name                = var.app2_vm2_network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.app2_vm2_virtual_machine_name}-IpConfig"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
    }

    depends_on = [
      azurerm_subnet.app-subnet
  ]

}

# Create APP2 VM2 virtual machine
resource "azurerm_virtual_machine" "linuxvm2" {
  name                  = var.app2_vm2_virtual_machine_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nicvm2.id]
  vm_size                  = "Standard_DS1_v2"
# Zone Information
  zones = [1]

  storage_os_disk {
    name                 = "${var.app2_vm2_virtual_machine_name}-OsDisk"
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
    computer_name                   = var.app2_vm2_virtual_machine_name
    admin_username                  = var.vm_admin_user
    admin_password                  = random_string.password_string.result
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }


  depends_on = [
    azurerm_resource_group.rg, azurerm_network_interface.nicvm2
  ]
 
}
# Script extesion to config app2 VM2
resource "azurerm_virtual_machine_extension" "vm2extension" {
  name                 = "appconfigscript"
  virtual_machine_id   = azurerm_virtual_machine.linuxvm2.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl -sL https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/app2.sh | bash -"
    }
SETTINGS
depends_on = [
    azurerm_virtual_machine.linuxvm2, azurerm_virtual_machine_extension.vm1extension
  ]

}