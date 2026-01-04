# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 User Assigned Identity          #
#                                                 #

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  location            = azurerm_resource_group.connectivity_primary_dns.location
  name                = "id-dns-remediation-${var.mgprefix}-${var.environment_type}-${var.region}"
  resource_group_name = azurerm_resource_group.connectivity_primary_dns.name
}

resource "azurerm_role_assignment" "assignment" {
  scope                = data.azurerm_management_group.top.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

#                                                 #
#           END User Assigned Identity            #
# +++++++++++++++++++++++++++++++++++++++++++++++ #