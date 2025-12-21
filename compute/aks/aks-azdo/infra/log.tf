# +++++++++++++++++++++++++++++++++++++++++++++++ #
#              Log Analytics Workspace            #
#                                                 #

resource "azurerm_log_analytics_workspace" "insights" {
  name                = "log-${var.workload}-${var.environment_type}-${var.region}-01"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "PerGB2018"
  retention_in_days   = 31
  daily_quota_gb      = 1

  tags = local.tags
  
  lifecycle {
    ignore_changes = [tags]
  }  
}

#                                                 #
#              END Log Analytics Workspace        #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
