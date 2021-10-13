#Zone creation
resource "azurerm_dns_zone" "dns_zone" {
  name                = "rdfapps.com"
  resource_group_name = var.network-rg-name

tags = {   
     COSTCENTER  = "INFRA"
     DEPT        = "APPS"
     ENV         = "PRD"
   }

 depends_on = [
  azurerm_resource_group.rgnet
  ] 
}

# A record definiotion for rdfapps.com
resource "azurerm_dns_a_record" "a_record_db" {
  name                = "db"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.network-rg-name
  ttl                 = 3600
  records             = ["${azurerm_network_interface.nicdbvm.private_ip_address}"]

 depends_on = [
      azurerm_resource_group.rgnet, azurerm_dns_zone.dns_zone, azurerm_network_interface.nicdbvm
 ]
}

# A record definiotion for rdfapps.com
resource "azurerm_dns_a_record" "a_record_appgw" {
  name                = "apps"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.network-rg-name
  ttl                 = 3600
  records             = ["${azurerm_public_ip.appgwpip.ip_address}"]

 depends_on = [
      azurerm_resource_group.rgnet, azurerm_dns_zone.dns_zone, azurerm_public_ip.appgwpip
 ]
}
