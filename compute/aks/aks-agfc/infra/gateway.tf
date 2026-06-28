# +++++++++++++++++++++++++++++++++++++++++++++++ #
#        Application Gateway for Containers       #
#                                                 #

resource "azurerm_application_load_balancer" "aks_agfc" {
  name                = "agfc-${var.workload}-${var.environment_type}-${var.region}-01"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [azurerm_user_assigned_identity.aks_agfc]
}

resource "azurerm_application_load_balancer_subnet_association" "aks_agfc" {
  name                         = "agfcsa-${var.workload}-${var.environment_type}-${var.region}-01"
  application_load_balancer_id = azurerm_application_load_balancer.aks_agfc.id
  subnet_id                    = azurerm_subnet.aks_agfc.id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_load_balancer_frontend" "aks_agfc" {
  name                         = "agfcfe-${var.workload}-${var.environment_type}-${var.region}-01"
  application_load_balancer_id = azurerm_application_load_balancer.aks_agfc.id

  lifecycle {
    ignore_changes = [tags]
  }
}

#                                                 #
#      END Application Gateway for Containers     #
# +++++++++++++++++++++++++++++++++++++++++++++++ #