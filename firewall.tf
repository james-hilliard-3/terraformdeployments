resource "azurerm_public_ip" "fw_public_ip" {
  name                = "fw-public-ip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"  # Corrected from 'sku_name' to 'sku'
}

resource "azurerm_firewall" "hub_firewall" {
  name                = "example-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_public_ip.id
  }

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  threat_intel_mode = "Alert"
}
