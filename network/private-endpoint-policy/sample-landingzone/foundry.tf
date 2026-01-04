# +++++++++++++++++++++++++++++++++++++++++++++++ #
#               AI Foundry Resources              #
#                                                 #

resource "azurerm_ai_services" "ai" {
  name                  = "ai-${var.workload}-foundry-${var.environment_type}-${var.region}-01"
  location              = azurerm_resource_group.ai.location
  resource_group_name   = azurerm_resource_group.ai.name
  sku_name              = "S0"

  custom_subdomain_name = coalesce(var.custom_subdomain_name, "azure-cognitive-${random_string.default_custom_subdomain_name_suffix.result}")
}

resource "azurerm_ai_foundry" "ai" {
  name                = "ai-${var.workload}-hub-${var.environment_type}-${var.region}-01"
  location            = azurerm_ai_services.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  storage_account_id  = azurerm_storage_account.ai.id
  key_vault_id        = azurerm_key_vault.ai.id

  identity {
    type = "SystemAssigned"
  }
}

#                                                 #
#            END AI Foundry Resources             #
# +++++++++++++++++++++++++++++++++++++++++++++++ #