#App GW Resrource group
resource "azurerm_resource_group" "rgappgw" {
  name     = var.appgw-rg-name
  location = var.apps-location

  tags = {   
     COSTCENTER  = "INFRA"
     DEPT        = "APPS"
     ENV         = "PRD"
   }
}

# App GW public IP
resource "azurerm_public_ip" "appgwpip" {
  name                = var.appgw-pip
  resource_group_name = azurerm_resource_group.rgappgw.name
  location            = azurerm_resource_group.rgappgw.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# App Gw configuration with zone redundancy
resource "azurerm_application_gateway" "appgwprd" {
  name                = "MyAppGW"
  resource_group_name = azurerm_resource_group.rgappgw.name
  location            = azurerm_resource_group.rgappgw.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  zones = [1,2]

  gateway_ip_configuration {
    name      = "MyAppGW-ip"
    subnet_id = azurerm_subnet.appgw-subnet.id
  }

  frontend_port {
    name = "http-frontend"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-pip"
    public_ip_address_id = azurerm_public_ip.appgwpip.id
  }

# listener for app2
  http_listener {
    name                           = "httplistener1"
    frontend_ip_configuration_name = "frontend-pip"
    frontend_port_name             = "http-frontend"
    protocol                       = "Http"
    host_name                      = ""
  }

  # backend for app2
  backend_address_pool {
    name = "app2pool"
    ip_addresses = [azurerm_network_interface.nicvm2.private_ip_address, azurerm_network_interface.nicvm1.private_ip_address]
  }

    backend_address_pool {
    name = "app1pool"
  }

# backup end http settings for apps
    backend_http_settings {
    name                  = "http_apps_end_settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

#URL path mappings for access the correct backend 
url_path_map {
  name                                   = "appsmapping"
  default_backend_address_pool_name      = "app2pool"
  default_backend_http_settings_name     = "http_apps_end_settings"

  path_rule {
    name                                 = "app2"
    paths                                = ["/app2*"]
    backend_address_pool_name            = "app2pool"
    backend_http_settings_name           = "http_apps_end_settings"
  }

   path_rule {
    name                                 = "app1"
    paths                                = ["/app1*"]
    backend_address_pool_name            = "app1pool"
    backend_http_settings_name           = "http_apps_end_settings"
  }

}

# Routing rule for app1 and app2
request_routing_rule {
   name                        = "routing-apps"
   rule_type                   = "PathBasedRouting"
   http_listener_name          = "httplistener1"
   url_path_map_name           = "appsmapping"
}

   depends_on = [
    azurerm_virtual_machine.linuxvm2, azurerm_virtual_machine.linuxvm1, azurerm_virtual_network.vnetprd, azurerm_public_ip.appgwpip, azurerm_virtual_machine_extension.vm1extension, azurerm_virtual_machine_extension.vm2extension
  ]
}
