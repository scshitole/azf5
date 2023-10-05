# Configure the Azure provider
provider "azurerm" {
  features {}
  client_id     = var.sp_client_id
  client_secret = var.sp_client_secret
  tenant_id     = var.sp_tenant_id
 subscription_id = var.sp_subscription_id
}

# Create a resource group
resource "azurerm_resource_group" "f5_rg" {
  name     = "f5-rg"
  location = "East US"
}

# Grant Virtual Machine Contributor role to SP at resource group scope
resource "azurerm_role_assignment" "sp_vm_role" {
  scope                = azurerm_resource_group.f5_rg.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = var.principal_id
}

# Create a virtual network
resource "azurerm_virtual_network" "f5_network" {
  name                = "f5-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.f5_rg.location
  resource_group_name = azurerm_resource_group.f5_rg.name
}

# Create a subnet for the BIG-IP
resource "azurerm_subnet" "f5_subnet" {
  name                 = "f5-subnet"
  resource_group_name  = azurerm_resource_group.f5_rg.name
  virtual_network_name = azurerm_virtual_network.f5_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP for the BIG-IP
resource "azurerm_public_ip" "f5_pip" {
  name                = "f5-pip"
  location            = azurerm_resource_group.f5_rg.location
  resource_group_name = azurerm_resource_group.f5_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create the BIG-IP network interface
resource "azurerm_network_interface" "f5_nic" {
  name                 = "f5-nic"
  location             = azurerm_resource_group.f5_rg.location
  resource_group_name  = azurerm_resource_group.f5_rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.f5_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
    public_ip_address_id          = azurerm_public_ip.f5_pip.id
  }
}

# Create the BIG-IP virtual machine
resource "azurerm_virtual_machine" "f5_vm" {
  name                  = "f5-vm"
  location              = azurerm_resource_group.f5_rg.location
  resource_group_name   = azurerm_resource_group.f5_rg.name
  network_interface_ids = [azurerm_network_interface.f5_nic.id]
  vm_size               = "Standard_DS3_v2"

  storage_image_reference {
    offer     = var.f5_product_name
    publisher = var.image_publisher
    sku       = var.f5_image_name
    version   = var.f5_version
  }

  storage_os_disk {
    name              = "f5-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "f5-vm"
    admin_username = "azureuser"
    admin_password = "Cisc0!2345"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  plan {
    name      = var.f5_image_name
    product   = var.f5_product_name
    publisher = var.image_publisher
  }


}
