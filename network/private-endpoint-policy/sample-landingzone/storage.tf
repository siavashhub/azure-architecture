# +++++++++++++++++++++++++++++++++++++++++++++++ #
#              Storage Account Resource           #
#                                                 #

resource "azurerm_storage_account" "ai" {
  name                     = "stai${random_integer.storage_suffix.result}"
  location                 = azurerm_resource_group.ai.location
  resource_group_name      = azurerm_resource_group.ai.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#                                                 #
#            END Storage Account Resource         #
# +++++++++++++++++++++++++++++++++++++++++++++++ #