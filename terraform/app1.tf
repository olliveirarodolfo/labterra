# Create a resource group for APP1
resource "azurerm_resource_group" "rgapp1" {
  name     = var.app1-rg-name
  location = var.apps-location

  tags = {   
     COSTCENTER  = "INFRA"
     DEPT        = "APPS"
     ENV         = "PRD"
   }
}

# Creating Linux VMSS
resource "azurerm_linux_virtual_machine_scale_set" "app1vmsslinux" {
  name                = var.app1-vmss
  resource_group_name = azurerm_resource_group.rgapp1.name
  location            = azurerm_resource_group.rgapp1.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_password = random_string.password_string.result
  disable_password_authentication = false
  admin_username      = var.vmmssadminusername

  zones = [1]
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "app1vmsscaleset-nic"
    primary = true

    ip_configuration {
      name                                          = "internal"
      primary                                       = true
      subnet_id                                     = azurerm_subnet.app-subnet.id
      # Attach VMSS to the backend pool app1pool defined in appgw.tf
      application_gateway_backend_address_pool_ids = ["${azurerm_application_gateway.appgwprd.backend_address_pool[1].id}"]        
    }
  }
 # script extension to config VMSS instances
  extension {
    name                         = "vmssconfigscript"
    publisher                    = "Microsoft.Azure.Extensions"
    type                         = "CustomScript"
    type_handler_version         = "2.0"
    
    settings = <<SETTINGS
  { 
    "commandToExecute": "curl -sL https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app1/app1.sh | bash -" 
  }
 SETTINGS
  }
  
    depends_on = [
      azurerm_subnet.app-subnet, azurerm_resource_group.rgapp1, azurerm_application_gateway.appgwprd
  ]
}

###### Autoscale rules condition configuration for Linux VMSS

resource "azurerm_monitor_autoscale_setting" "autoscaleforapp1vmss" {
  name                = "app1vmsssalerules"
  resource_group_name = azurerm_resource_group.rgapp1.name
  location            = azurerm_resource_group.rgapp1.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.app1vmsslinux.id

  profile {
    name = "autoscaledefaultrule"

    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.app1vmsslinux.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.app1vmsslinux.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = [var.admin-mail]
    }
  }

   depends_on = [
      azurerm_linux_virtual_machine_scale_set.app1vmsslinux
  ]
}