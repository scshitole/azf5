data "azurerm_client_config" "current" {}



resource "azurerm_key_vault" "scsAzPKI" {
  name                        = "scsAzPKIkeyvault"
  location                    = azurerm_resource_group.f5_rg.location
  resource_group_name         = azurerm_resource_group.f5_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_automation_account" "scsAzPKI" {
  name                = "scsAzPKI-account"
  location            = azurerm_resource_group.f5_rg.location
  resource_group_name = azurerm_resource_group.f5_rg.name
  sku_name            = "Basic"

  tags = {
    environment = "development"
  }
}

data "local_file" "scsAzPKI" {
  filename = "${path.module}/script.ps1"
}

/**resource "azurerm_automation_runbook" "scsAzPKI" {
  name                    = "Get-AzureAzPKITutorial"
  location                = azurerm_resource_group.scsAzPKI.location
  resource_group_name     = azurerm_resource_group.scsAzPKI.name
  automation_account_name = azurerm_automation_account.scsAzPKI.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This is an scsAzPKI runbook"
  runbook_type            = "PowerShell"

  content = data.local_file.scsAzPKI.content
} **/
