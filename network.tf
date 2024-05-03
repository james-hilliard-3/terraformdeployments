# Resource Group for Hub
resource "azurerm_resource_group" "hub_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Hub VNet
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

# Subnet for Application Gateway in the Hub VNet
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.appgw_subnet_prefix
}

# Subnet for Azure Firewall in the Hub VNet
resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.fw_subnet_prefix
}

# Resource Group for Management VNet
resource "azurerm_resource_group" "mgmt_rg" {
  name     = var.mgmt_rg_name
  location = var.location
}

# Management VNet
resource "azurerm_virtual_network" "mgmt_vnet" {
  name                = "mgmt-vnet"
  address_space       = var.mgmt_vnet_address_space
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name
}

# Management Subnet
resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "mgmt-subnet"
  resource_group_name  = azurerm_resource_group.mgmt_rg.name
  virtual_network_name = azurerm_virtual_network.mgmt_vnet.name
  address_prefixes     = var.mgmt_subnet_prefix
}

# Network Security Group for Management Subnet
resource "azurerm_network_security_group" "mgmt_nsg" {
  name                = "mgmt-nsg"
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name
}

# Associate NSG to Management Subnet
resource "azurerm_subnet_network_security_group_association" "mgmt_nsg_association" {
  subnet_id                 = azurerm_subnet.mgmt_subnet.id
  network_security_group_id = azurerm_network_security_group.mgmt_nsg.id
}

resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "appgw-public-ip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Route Table for Management Subnet with default route to Azure Firewall
resource "azurerm_route_table" "mgmt_route_table" {
  name                = "mgmt-route-table"
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name
}

resource "azurerm_route" "default_to_fw" {
  name                    = "default-route"
  resource_group_name     = azurerm_resource_group.mgmt_rg.name
  route_table_name        = azurerm_route_table.mgmt_route_table.name
  address_prefix          = "0.0.0.0/0"
  next_hop_type           = "VirtualAppliance"
  next_hop_in_ip_address  = var.fw_ip_address
}


# Associate Route Table to Management Subnet
resource "azurerm_subnet_route_table_association" "mgmt_route_table_association" {
  subnet_id      = azurerm_subnet.mgmt_subnet.id
  route_table_id = azurerm_route_table.mgmt_route_table.id
}

# Peering between Hub VNet and Management VNet
resource "azurerm_virtual_network_peering" "hub_to_mgmt_peering" {
  name                      = "hub-to-mgmt-peering"
  resource_group_name       = azurerm_resource_group.hub_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.mgmt_vnet.id
}

resource "azurerm_virtual_network_peering" "mgmt_to_hub_peering" {
  name                      = "mgmt-to-hub-peering"
  resource_group_name       = azurerm_resource_group.mgmt_rg.name
  virtual_network_name      = azurerm_virtual_network.mgmt_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
}
