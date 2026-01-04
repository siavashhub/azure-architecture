# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 Key Vault Resource              #
#                                                 #

resource "azurerm_key_vault" "ai" {
  name                = "kvai${random_integer.storage_suffix.result}"
  location            = azurerm_resource_group.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                 = "standard"
  purge_protection_enabled = true
}

#                                                 #
#              END Key Vault Resource             #
# +++++++++++++++++++++++++++++++++++++++++++++++ #