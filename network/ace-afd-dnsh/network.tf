# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                  Virtual Networks               #
#                                                 #

resource "azurerm_virtual_network" "ace_1" {
  name                = "vnet-${var.workload}-${var.environment_type}-${var.region}-001"
  location            = azurerm_resource_group.ace_1_app.location
  resource_group_name = azurerm_resource_group.ace_1_app.name
  address_space       = var.network.app1_virtual_network_address_space

  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_virtual_network" "ace_2" {
  name                = "vnet-${var.workload}-${var.environment_type}-${var.region}-002"
  location            = azurerm_resource_group.ace_2_app.location
  resource_group_name = azurerm_resource_group.ace_2_app.name
  address_space       = var.network.app2_virtual_network_address_space

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

# Subnet for ACE 1
resource "azurerm_subnet" "ace_1" {
  name                 = "snet-${var.workload}-aca-${var.environment_type}-${var.region}-001"
  virtual_network_name = azurerm_virtual_network.ace_1.name
  resource_group_name  = azurerm_virtual_network.ace_1.resource_group_name
  address_prefixes     = [var.network.app1_subnet_address_space[0]]

  delegation {
    name = "aca"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Subnet for ACE 2
resource "azurerm_subnet" "ace_2" {
  name                 = "snet-${var.workload}-aca-${var.environment_type}-${var.region}-002"
  virtual_network_name = azurerm_virtual_network.ace_2.name
  resource_group_name  = azurerm_virtual_network.ace_2.resource_group_name
  address_prefixes     = [var.network.app2_subnet_address_space[0]]

  delegation {
    name = "aca"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

#                                                 #
#                    END Subnets                  #
# +++++++++++++++++++++++++++++++++++++++++++++++ #


# +++++++++++++++++++++++++++++++++++++++++++++++ #
#               Network Peerings                  #
#                                                 #

resource "azurerm_virtual_network_peering" "ace_1_ace_2" {
  name                      = "peer-${azurerm_virtual_network.ace_1.name}-${azurerm_virtual_network.ace_2.name}"
  resource_group_name       = azurerm_virtual_network.ace_1.resource_group_name
  virtual_network_name      = azurerm_virtual_network.ace_1.name
  remote_virtual_network_id = azurerm_virtual_network.ace_2.id

  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "ace_2_ace_1" {
  name                      = "peer-${azurerm_virtual_network.ace_2.name}-${azurerm_virtual_network.ace_1.name}"
  resource_group_name       = azurerm_virtual_network.ace_2.resource_group_name
  virtual_network_name      = azurerm_virtual_network.ace_2.name
  remote_virtual_network_id = azurerm_virtual_network.ace_1.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

#                                                 #
#                END Network Peerings             #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
