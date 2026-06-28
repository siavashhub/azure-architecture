resource "azurerm_user_assigned_identity" "aks_agfc" {
  name                = "id-${var.workload}-agfc-${var.environment_type}-${var.region}-01"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "alb_reader" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_agfc.principal_id
}

# Delegate AppGw for Containers Configuration Manager role to RG containing Application Gateway for Containers resource
resource "azurerm_role_assignment" "agfc_config_manager" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "AppGw for Containers Configuration Manager"
  #   role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fbc52c3f-28ad-4303-a892-8a056630b8f1"
  principal_id = azurerm_user_assigned_identity.aks_agfc.principal_id
}

# Delegate Network Contributor permission for join to association subnet
resource "azurerm_role_assignment" "agfc_subnet_network_contributor" {
  scope                = azurerm_subnet.aks_agfc.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_agfc.principal_id
}

resource "azurerm_federated_identity_credential" "aks_agfc" {
  name                = "azure-alb-identity" # DO NOT CHANGE!
  resource_group_name = azurerm_resource_group.aks.name
  parent_id           = azurerm_user_assigned_identity.aks_agfc.id

  issuer   = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  subject  = "system:serviceaccount:azure-alb-system:alb-controller-sa"
  audience = ["api://AzureADTokenExchange"]
}
