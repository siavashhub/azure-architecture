# +++++++++++++++++++++++++++++++++++++++++++++++ #
#              Log Analytics Workspace            #
#                                                 #

resource "azurerm_log_analytics_workspace" "ace" {
  name                = "logs-${var.workload}-${var.environment_type}-${var.region}-001"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 5

  lifecycle {
    ignore_changes = [tags]
  }
}

#                                                 #
#              END Log Analytics Workspace        #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
