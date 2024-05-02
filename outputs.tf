output "app_gateway_public_ip" {
  value = azurerm_public_ip.appgw_public_ip.ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.fw_public_ip.ip_address
}
