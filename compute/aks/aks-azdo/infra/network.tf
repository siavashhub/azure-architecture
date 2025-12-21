# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                  Virtual Networks               #
#                                                 #

resource "azurerm_virtual_network" "aks" {
  name                = "vnet-${var.workload}-${var.region}-${var.environment_type}-01"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.network.aks_virtual_network_address_space[0]]

  tags = local.tags

  lifecycle {
    ignore_changes = [tags]
  }  
}

#                                                 #
#                END Virtual Networks             #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                  Subnets                        #
#                                                 #

resource "azurerm_subnet" "aks_nodes" {
  name                 = "snet-${var.workload}-nodes-${var.region}-${var.environment_type}-01"
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.network.name
  address_prefixes     = [var.network.aks_subnet_address_space[0]]
}

#                                                 #
#                    END Subnets                  #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
