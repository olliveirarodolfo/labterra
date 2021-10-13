# Main Variables
variable "subscription_context" {
  type = string
  description = "Subscription ID"
}

variable "admin-mail" {
  type        = string
  description = "Admin Mail for notification"
}

# Variables for VNET
variable "network-rg-name" {
  type        = string
  description = "Network Resource Group"
}

variable "network-location" {
  type        = string
  description = "Region for Network"
  default     = "eastus2"
}

variable "network-vnet-name" {
  type        = string
  description = "Virtual Network Name"
}

variable "network-vnet-address-space" {
  type        = list(any)
  description = "IP Address Space for Virtual Network "
}

variable "app-subnet-name" {
  type        = string
  description = "app subnet name"
}

variable "db-subnet-name" {
  type        = string
  description = "db subnet name"
}

variable "app-subnet-address-prefixes" {
  type        = list(any)
  description = "APP subnet IP Prefixes"
}

variable "db-subnet-address-prefixes" {
  type        = list(any)
  description = "DB subnet IP Prefixes"
} 

variable "network-vnet-nsg-name" {
  type        = string
  description = "NSG DEV subnet name"
}

# Variable for APP2  VMs

#VM1
variable "app2-rg-name" {
  type        = string
  description = "App2 Resource Group"
}

variable "apps-location" {
  type        = string
  description = "Region for apps"
  default     = "eastus2"
}

variable "app2_vm1_network_interface_name" {
  type        = string
  description = "NIC for app2 name in Azure"
}

variable "app2_vm1_virtual_machine_name" {
  type        = string
  description = "APP2 Linux VM1 name in Azure"
}

variable "vm_admin_user" {
  type = string
  description  = "Initial admin username"
}

#VM2

variable "app2_vm2_network_interface_name" {
  type        = string
  description = "NIC for app2 name in Azure"
}

variable "app2_vm2_virtual_machine_name" {
  type        = string
  description = "APP2 Linux VM2 name in Azure"
}

variable "app1-rg-name" {
  type        = string
  description = "App1 Resource Group"
}

# VMSS variables

variable "app1-vmss" {
  type        = string
  description = "APP1 Linux VMSS name in Azure"
}

variable "vmmssadminusername" {
  type        = string
  description = "VMSS admin username"
}


# Variables for AppGW VMs

variable "appgw-rg-name" {
  type        = string
  description = "AppGW Resource Group"
}

variable "appgw-subnet-name" {
  type        = string
  description = "App GW Subnet Name"
}

variable "appgw-subnet-address-prefixes" {
  type        = list(any)
  description = "App GW subnet IP Prefixes"
}

variable "appgw-pip" {
  type        = string
  description = "App GW PIP Name"
}

# Variables for Database VM
variable "db-rg-name" {
  type        = string
  description = "DB RG Name"
}

variable "db_vm_network_interface_name" {
  type        = string
  description = "DB Interface name"
}

variable "db_vm_virtual_machine_name" {
  type        = string
  description = "DB VM name"
}


# Variables for NSGs
variable "nsg-app-name" {
  type        = string
  description = "NSG for APPs vnet"
}

variable "nsg-db-name" {
  type        = string
  description = "NSG for DB vnet"
}