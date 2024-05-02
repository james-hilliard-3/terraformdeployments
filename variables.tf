variable "location" {
    description = "The Azure Region in which all resources in this example should be created."
    default     = "East US"
  }
  
  variable "resource_group_name" {
    description = "Name of the resource group for the hub."
    default     = "hub-resources"
  }
  
  variable "mgmt_rg_name" {
    description = "Resource group name for the management VNet."
    default     = "mgmt-resources"
  }
  
  variable "vnet_address_space" {
    description = "The address space for the Hub VNet."
    default     = ["10.0.0.0/16"]
  }
  
  variable "mgmt_vnet_address_space" {
    description = "Address space for the management VNet."
    default     = ["10.2.0.0/16"]
  }
  
  variable "appgw_subnet_prefix" {
    description = "Subnet prefix for the Application Gateway."
    default     = ["10.0.1.0/24"]
  }
  
  variable "fw_subnet_prefix" {
    description = "Subnet prefix for the Azure Firewall."
    default     = ["10.0.2.0/24"]
  }
  
  variable "mgmt_subnet_prefix" {
    description = "Subnet prefix for the management subnet."
    default     = ["10.2.1.0/24"]
  }
  
  variable "fw_ip_address" {
    description = "IP address of the Azure Firewall used as next hop."
    default     = "10.0.2.4"
  }
  