# Main varaibles
subscription_context        = "xxxxxx-xxxx-xxxx-xxxx-xxxxxx"

# Variables for VNET
network-rg-name                 = "RG-VNET"
network-location                = "eastus2"
network-vnet-name               = "VNET-EASTUS2-PRD01"
network-vnet-address-space      = ["10.10.0.0/16"]
network-vnet-nsg-name           = "NSG-VNET-EASTUS2-PRD01"

#App Subnet Config
app-subnet-name                 = "SNET-EASTUS2-APP"
app-subnet-address-prefixes = ["10.10.1.0/24"]

#DB Subnet Config
db-subnet-name                  = "SNET-EASTUS2-DB"
db-subnet-address-prefixes = ["10.10.2.0/24"]

# Variable for APP2 VM1 
app2-rg-name                        = "RG-APP2"
apps-location                       = "eastus2"
app2_vm1_network_interface_name     = "app2vm1-nic"
app2_vm1_virtual_machine_name       = "app2vm1"
vm_admin_user                       = "rdfaccess"

# Variable for APP2 VM2
app2_vm2_network_interface_name     = "app2vm2-nic"
app2_vm2_virtual_machine_name       = "app2vm2"

# Variables for APPGW
appgw-rg-name                        = "RG-APPGW"
appgw-subnet-name                    = "AppGwSubnet"
appgw-subnet-address-prefixes        = ["10.10.0.0/24"]
appgw-pip                            = "appgw-pip"  

#Variables for APP1
vmmssadminusername                  = "rdfadmin"
app1-rg-name                        = "RG-APP1"
app1-vmss                           = "app1vmsslinux"
admin-mail                          = "admin@youremail.com"

#Variables for DB VM
db-rg-name                          = "RG-DATABASE"
db_vm_network_interface_name        = "dbvm-nic"
db_vm_virtual_machine_name          = "dbvm"

#Variables for NSG
nsg-app-name                        = "NSG-APP-SUBNET"
nsg-db-name                         = "NSG-DB-SUBNET"