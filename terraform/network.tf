# Resource Group DEV Region
resource "azurerm_resource_group" "rgnet" {
  provider = azurerm
  name     = var.network-rg-name
  location = var.network-location

  tags = {
     
     COSTCENTER  = "INFRA"
     DEPT        = "APPS"
     ENV         = "PRD"

   }
}

# Virtual Network Config
resource "azurerm_virtual_network" "vnetprd" {
  provider            = azurerm
  name                = var.network-vnet-name 
  location            = azurerm_resource_group.rgnet.location
  resource_group_name = azurerm_resource_group.rgnet.name
  address_space       = var.network-vnet-address-space
 
  tags = {
     COSTCENTER  = "INFRA"
     DEPT        = "APPS"
     ENV         = "PRD"
  }

     depends_on = [
      azurerm_resource_group.rgnet 
  ]
}

# App  Subnet
resource "azurerm_subnet" "app-subnet" {
  provider             = azurerm
  name                 = var.app-subnet-name
  resource_group_name  = azurerm_resource_group.rgnet.name
  virtual_network_name = azurerm_virtual_network.vnetprd.name
  address_prefixes     = var.app-subnet-address-prefixes

     depends_on = [
      azurerm_virtual_network.vnetprd 
  ]
}

# DB Subnet
resource "azurerm_subnet" "db-subnet" {
  provider             = azurerm
  name                 = var.db-subnet-name
  resource_group_name  = azurerm_resource_group.rgnet.name
  virtual_network_name = azurerm_virtual_network.vnetprd.name
  address_prefixes     = var.db-subnet-address-prefixes

     depends_on = [
      azurerm_virtual_network.vnetprd 
  ]
}


# AppGwSubnet

resource "azurerm_subnet" "appgw-subnet" {
  provider             = azurerm
  name                 = var.appgw-subnet-name
  resource_group_name  = azurerm_resource_group.rgnet.name
  virtual_network_name = azurerm_virtual_network.vnetprd.name
  address_prefixes     = var.appgw-subnet-address-prefixes

     depends_on = [
      azurerm_virtual_network.vnetprd 
  ]
}