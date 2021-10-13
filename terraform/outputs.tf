# APP2 VM1 outputs
output "vm1_id" {
  value = azurerm_virtual_machine.linuxvm1.id
}

output "vm1_ip" {
  value = azurerm_network_interface.nicvm1.private_ip_address
}

output "vm1_user" {
  value = var.vm_admin_user
  
}
output "vm1_password" {
  value = random_string.password_string.result
}


# APP2 VM2 outputs
output "vm2_id" {
  value = azurerm_virtual_machine.linuxvm2.id
}

output "vm2_ip" {
  value = azurerm_network_interface.nicvm2.private_ip_address
}

output "vm2_user" {
  value = var.vm_admin_user
  
}
output "vm2_password" {
  value = random_string.password_string.result
}

#APP1 outputs

# APP GW Outputs
output "appgw_name" {
  value = azurerm_application_gateway.appgwprd.name
}

output "appgw_id" {
  value = azurerm_application_gateway.appgwprd.id
}

output "appgw_backend_address_pool" {
  value = azurerm_application_gateway.appgwprd.backend_address_pool
}

output "backend_address_pool_POSIX0" {
  value = "${azurerm_application_gateway.appgwprd.backend_address_pool[0].id}"
}

output "backend_address_pool_POSIX1" {
  value = "${azurerm_application_gateway.appgwprd.backend_address_pool[1].id}"
}

