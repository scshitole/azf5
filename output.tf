
output "f5_public_ip" {
  value = "https://${azurerm_public_ip.f5_pip.ip_address}:8443"
}

