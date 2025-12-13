# +++++++++++++++++++++++++++++++++++++++++++++++ #
#              Managed Environments               #
#                                                 #

resource "azurerm_container_app_environment" "ace_1" {
  name                       = "cae-${var.workload}-${var.environment_type}-${var.region}-001"
  location                   = azurerm_resource_group.ace_1_app.location
  resource_group_name        = azurerm_resource_group.ace_1_app.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.ace.id

  infrastructure_subnet_id = azurerm_subnet.ace_1.id

  internal_load_balancer_enabled = true
  public_network_access = "Disabled"

  infrastructure_resource_group_name = "rg-ME_cae-${var.workload}-${var.environment_type}-${var.region}-001"

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_container_app_environment" "ace_2" {
  name                       = "cae-${var.workload}-${var.environment_type}-${var.region}-002"
  location                   = azurerm_resource_group.ace_2_app.location
  resource_group_name        = azurerm_resource_group.ace_2_app.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.ace.id

  infrastructure_subnet_id = azurerm_subnet.ace_2.id

  internal_load_balancer_enabled = true
  public_network_access = "Disabled"

  infrastructure_resource_group_name = "rg-ME_cae-${var.workload}-${var.environment_type}-${var.region}-002"

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  # to help with ACE provisioning state issues
  depends_on = [ azurerm_container_app_environment.ace_1 ]  
}

#                                                 #
#          END Managed Environments               #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#        Private Endpoint Connection Approval     #
#                                                 #

data "azapi_resource_list" "ace_1_privateEndpointConnections" {
  type                   = "Microsoft.App/managedEnvironments/privateEndpointConnections@2024-10-02-preview"
  parent_id              = azurerm_container_app_environment.ace_1.id
  response_export_values = ["*"]

  depends_on = [ azurerm_cdn_frontdoor_route.app1 ]
}

data "azapi_resource_list" "ace_2_privateEndpointConnections" {
  type                   = "Microsoft.App/managedEnvironments/privateEndpointConnections@2024-10-02-preview"
  parent_id              = azurerm_container_app_environment.ace_2.id
  response_export_values = ["*"]

  depends_on = [ azurerm_cdn_frontdoor_route.app2 ]  
}

resource "azapi_update_resource" "ace_1_privateEndpointConnection" {
  type        = "Microsoft.App/managedEnvironments/privateEndpointConnections@2024-10-02-preview"
  # take the first returned PE id
  resource_id = data.azapi_resource_list.ace_1_privateEndpointConnections.output.value[0].id

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        status          = "Approved"
        description     = "Auto-approved"
        actionsRequired = "None"
      }
    }
  }
}

resource "azapi_update_resource" "ace_2_privateEndpointConnection" {
  type        = "Microsoft.App/managedEnvironments/privateEndpointConnections@2024-10-02-preview"
  resource_id = data.azapi_resource_list.ace_2_privateEndpointConnections.output.value[0].id

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        status          = "Approved"
        description     = "Auto-approved"
        actionsRequired = "None"
      }
    }
  }
}

#                                                 #
#    END Private Endpoint Connection Approval     #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
