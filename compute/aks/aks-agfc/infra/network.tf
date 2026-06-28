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

resource "azurerm_subnet" "aks_agfc" {
  name                 = "snet-${var.workload}-agfc-${var.region}-${var.environment_type}-01"
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.network.name
  address_prefixes     = [var.network.aks_subnet_address_space[1]]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ServiceNetworking/trafficControllers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

#                                                 #
#                    END Subnets                  #
# +++++++++++++++++++++++++++++++++++++++++++++++ #


# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                     NSG                         #
#                                                 #

resource "azurerm_network_security_group" "aks_agfc" {
  name                = "nsg-${var.workload}-agfc-${var.region}-${var.environment_type}-01"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowInternetHttpHttpsInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "app_gwsubnet" {
  subnet_id                 = azurerm_subnet.aks_agfc.id
  network_security_group_id = azurerm_network_security_group.aks_agfc.id
}

#                                                 #
#                    END NSG                      #
# +++++++++++++++++++++++++++++++++++++++++++++++ #