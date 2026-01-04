# +++++++++++++++++++++++++++++++++++++++++++++++ #
#              Private Endpoint Resources         #
#                                                 #

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault" {
  name                          = "pe-${azurerm_key_vault.ai.name}"
  location                      = azurerm_resource_group.ai.location
  resource_group_name           = azurerm_resource_group.ai.name
  subnet_id                     = azurerm_subnet.private_endpoints.id
  custom_network_interface_name = "nic-pe-${azurerm_key_vault.ai.name}"

  private_service_connection {
    name                           = "psc-${azurerm_key_vault.ai.name}"
    private_connection_resource_id = azurerm_key_vault.ai.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

# Private Endpoint for Storage Account
resource "azurerm_private_endpoint" "storage" {
  name                          = "pe-${azurerm_storage_account.ai.name}"
  location                      = azurerm_resource_group.ai.location
  resource_group_name           = azurerm_resource_group.ai.name
  subnet_id                     = azurerm_subnet.private_endpoints.id
  custom_network_interface_name = "nic-pe-${azurerm_storage_account.ai.name}"
  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ai.name}"
    private_connection_resource_id = azurerm_storage_account.ai.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# Private Endpoint for AI Foundry
resource "azurerm_private_endpoint" "ai_foundry" {
  name                          = "pe-${azurerm_ai_foundry.ai.name}"
  location                      = azurerm_resource_group.ai.location
  resource_group_name           = azurerm_resource_group.ai.name
  subnet_id                     = azurerm_subnet.private_endpoints.id
  custom_network_interface_name = "nic-pe-${azurerm_ai_foundry.ai.name}"

  private_service_connection {
    name                           = "psc-${azurerm_ai_foundry.ai.name}"
    private_connection_resource_id = azurerm_ai_foundry.ai.id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
  }
}

# Private Endpoint for AI Services
resource "azurerm_private_endpoint" "ai_services" {
  name                          = "pe-${azurerm_ai_services.ai.name}"
  location                      = azurerm_resource_group.ai.location
  resource_group_name           = azurerm_resource_group.ai.name
  subnet_id                     = azurerm_subnet.private_endpoints.id
  custom_network_interface_name = "nic-pe-${azurerm_ai_services.ai.name}"

  tags = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_ai_services.ai.name}"
    private_connection_resource_id = azurerm_ai_services.ai.id
        is_manual_connection       = false
    subresource_names              = ["account"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }  
}

#                                                 #
#          END Private Endpoint Resources         #
# +++++++++++++++++++++++++++++++++++++++++++++++ #