 Create NSG for BIG-IP subnet
resource "azurerm_network_security_group" "f5_nsg" {
  name                = "f5-subnet-nsg"
  location            = azurerm_resource_group.f5_rg.location
  resource_group_name = azurerm_resource_group.f5_rg.name
}

# Allow SSH from laptop IP 
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.myip # LAPTOP IP
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.f5_rg.name
  network_security_group_name = azurerm_network_security_group.f5_nsg.name
}

# Allow HTTPS from laptop IP
resource "azurerm_network_security_rule" "allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = var.myip # LAPTOP IP
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.f5_rg.name
  network_security_group_name = azurerm_network_security_group.f5_nsg.name
}

# Associate NSG with BIG-IP subnet
resource "azurerm_subnet_network_security_group_association" "f5_subnet_nsg" {
  subnet_id                 = azurerm_subnet.f5_subnet.id
  network_security_group_id = azurerm_network_security_group.f5_nsg.id
}

