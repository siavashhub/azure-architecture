# +++++++++++++++++++++++++++++++++++++++++++++++ #
#             Virtual Network & Subnet            #
#                                                 #

resource "azurerm_virtual_network" "ai" {
  name                = "vnet-${var.workload}-${var.environment_type}-${var.region}-01"
  location            = azurerm_resource_group.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  address_space       = var.network.virtual_network_address_space

  tags = local.tags
}

#                                                 #
#        END Virtual Network & Subnet             #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                  Subnet Resource                #
#                                                 #

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-${var.workload}-pep-${var.environment_type}-${var.region}-01"
  virtual_network_name = azurerm_virtual_network.ai.name
  resource_group_name  = azurerm_resource_group.ai.name

  address_prefixes     = [var.network.subnet_address_space[0]]

  service_endpoints    = ["Microsoft.CognitiveServices"]

  private_endpoint_network_policies = "Enabled"

}

#                                                 #
#              END Subnet Resource                # 
# +++++++++++++++++++++++++++++++++++++++++++++++ #