
# +++++++++++++++++++++++++++++++++++++++++++++++ #
#           Azure PaaS Private DNS Policy         #
#                                                 #

resource "azurerm_policy_definition" "policy" {
  name                = "AzurePaaSPrivateDNSZone"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Configure Azure PaaS services to use private DNS zones"
  management_group_id = data.azurerm_management_group.top.id

  metadata = <<METADATA
    {
    "category": "Network"
    }
METADATA

  policy_rule = <<POLICY_RULE
 {
        "if": {
          "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Network/privateEndpoints"
            },
            {
              "count": {
                "field": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*]",
                "where": {
                  "allOf": [
                    {
                      "field": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].privateLinkServiceId",
                      "contains": "[parameters('privateEndpointPrivateLinkServiceId')]"
                    },
                    {
                      "field": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]",
                      "equals": "[parameters('privateEndpointGroupId')]"
                    }
                  ]
                }
              },
              "greaterOrEquals": 1
            }
          ]
        },
        "then": {
          "effect": "[parameters('effect')]",
          "details": {
            "type": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",
            "evaluationDelay": "AfterProvisioningSuccess",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "name": "parameters('privateEndpointPrivateLinkServiceId')",
                "template": {
                  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "privateDnsZoneIds": {
                      "type": "array"
                    },
                    "privateEndpointName": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    }
                  },
                  "resources": [
                    {
                        "type": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",
                        "apiVersion": "2020-03-01",
                        "name": "[concat(parameters('privateEndpointName'), '/deployedByPolicy')]",
                        "location": "[parameters('location')]",
                        "properties": {
                            "copy": [
                                {
                                    "name": "privateDnsZoneConfigs",
                                    "count": "[length(parameters('privateDnsZoneIds'))]",
                                    "input": {
                                        "name": "[concat(last(split(parameters('privateDnsZoneIds')[copyIndex('privateDnsZoneConfigs')], '/')), '-', parameters('privateEndpointName'))]",
                                        "properties": {
                                            "privateDnsZoneId": "[parameters('privateDnsZoneIds')[copyIndex('privateDnsZoneConfigs')]]"
                                        }
                                    }
                                }
                            ]
                        }
                    }
                  ]
                },
                "parameters": {
                  "privateDnsZoneIds": {
                    "value": "[parameters('privateDnsZoneIds')]"
                  },
                  "privateEndpointName": {
                    "value": "[field('name')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  }
                }
              }
            }
          }
        }
      }
POLICY_RULE

  parameters = <<PARAMETERS
{
        "privateDnsZoneIds": {
          "type": "array",
          "metadata": {
            "displayName": "Array of Private Dns Zone Id",
            "description": "The list of private DNS zone to deploy in a new private DNS zone group and link to the private endpoint"
          }
        },
        "privateEndpointPrivateLinkServiceId": {
          "type": "string",
          "metadata": {
            "displayName": "Private Endpoint Link Service Id",
            "description": "A group Id for the private endpoint"
          }
        },
        "privateEndpointGroupId": {
          "type": "string",
          "metadata": {
            "displayName": "Private Endpoint Group Id",
            "description": "A group Id for the private endpoint"
          }
        },
        "effect": {
          "type": "string",
          "metadata": {
            "displayName": "Effect",
            "description": "Enable or disable the execution of the policy"
          },
          "allowedValues": [
            "DeployIfNotExists",
            "Disabled"
          ],
          "defaultValue": "DeployIfNotExists"
        }
      }
PARAMETERS
}

#                                                 #
#         END Azure PaaS Private DNS Policy       #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#        Deny Private DNS Zone Creation Policy    #
#                                                 #
resource "azurerm_policy_definition" "deny_policy" {
  count = var.deny_prive_dns_zone_creation ? 1 : 0
  name         = "DenyPrivateDNSZones"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny the creation of private DNS Zones"
  description  = "This policy denies the creation of a private DNS in the current scope, used in combination with policies that create centralized private DNS in connectivity subscription"

  management_group_id = data.azurerm_management_group.top.id

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = <<POLICY_RULE
{
      "if": {
        "field": "type",
        "equals": "Microsoft.Network/privateDnsZones"
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
POLICY_RULE

  parameters = <<PARAMETERS
{
      "effect": {
        "type": "string",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Deny",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        }
      }
    }
PARAMETERS
}

#                                                 #
#      END Deny Private DNS Zone Creation Policy  #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#         Policy Assignments for DNS Zones        #
#                                                 #
resource "azurerm_management_group_policy_assignment" "policy_assignment" {
  for_each             = local.private_dns_zones_policy
  name                 = random_id.dns_zone_policy[each.key].id
  display_name         = "Azure PaaS Private DNS Zone - ${each.value.privateLinkServiceId}/${each.value.groupId}"
  management_group_id  = data.azurerm_management_group.top.id
  policy_definition_id = azurerm_policy_definition.policy.id
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }
  location = var.location

  parameters = jsonencode({
    privateDnsZoneIds = {
      value = [for s in each.value.zones : azurerm_private_dns_zone.private_dns_zones[s].id]
    }
    privateEndpointPrivateLinkServiceId = {
      value = each.value.privateLinkServiceId
    }
    privateEndpointGroupId = {
      value = each.value.groupId
    }
  })
}

resource "azurerm_management_group_policy_assignment" "deny_private_dns_zones_assignment" {
  count = var.deny_prive_dns_zone_creation ? 1 : 0
  name                 = random_id.deny_private_dns_zones_id[0].id
  management_group_id  = data.azurerm_management_group.top.id
  policy_definition_id = azurerm_policy_definition.deny_policy[0].id
  display_name         = "Deny Private DNS Zones outside of the DNS Resource Group"
  non_compliance_message {
    content = "Private DNS Zones are not allowed outside of the DNS Resource Group"
  }
  enforce    = true
  not_scopes = [azurerm_resource_group.connectivity_primary_dns.id]
}

#                                                 #
#      END Policy Assignments for DNS Zones       #
# +++++++++++++++++++++++++++++++++++++++++++++++ #