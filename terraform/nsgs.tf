# ALL NSGs definitions for the subnets in the prd VNET
# NSG for App Subnet
resource "azurerm_network_security_group" "nsgsubnetapp" {
    name =                    var.nsg-app-name
    location =                var.apps-location
    resource_group_name =     var.network-rg-name

    security_rule {
        name                        = "HttpAccess-Rule"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "80"
        source_address_prefix       = "VirtualNetwork"
        destination_address_prefix  = "*"
    }

         depends_on = [
      azurerm_resource_group.rgnet 
  ]
}

# NSG for DB Subnet
resource "azurerm_network_security_group" "nsgsubnetdb" {
    name =                    var.nsg-db-name
    location =                var.apps-location
    resource_group_name =     var.network-rg-name

    security_rule {
        name                        = "MySqlAccess-rule"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "3306"
        source_address_prefix       = "10.10.1.0/24"
        destination_address_prefix  = "*"
    }

     security_rule {
        name                        = "BlockAllIncoming-Rule"
        priority                    = 4096
        direction                   = "Inbound"
        access                      = "Deny"
        protocol                    = "*"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
    }



         depends_on = [
      azurerm_resource_group.rgnet 
  ]
}

#NSG Association for appsubnet
resource "azurerm_subnet_network_security_group_association" "toappsubnet" {
    subnet_id = "${azurerm_subnet.app-subnet.id}"
    network_security_group_id = azurerm_network_security_group.nsgsubnetapp.id

   depends_on = [
      azurerm_monitor_autoscale_setting.autoscaleforapp1vmss, azurerm_network_security_group.nsgsubnetdb
  ]
}

#NSG Association for dbsubnet
resource "azurerm_subnet_network_security_group_association" "todbsubnet" {
    subnet_id = "${azurerm_subnet.db-subnet.id}"
    network_security_group_id = azurerm_network_security_group.nsgsubnetdb.id

    depends_on = [
      azurerm_monitor_autoscale_setting.autoscaleforapp1vmss, azurerm_network_security_group.nsgsubnetdb
  ]
}
