# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                       Keys                      #
#                                                 #

resource "azurerm_ssh_public_key" "aks-key" {
  name                = "ssh-${var.workload}-${var.environment_type}-${var.region}-01"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  public_key          = file(var.ssh_public_key)

  tags = local.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

#                                                 #
#                     END Keys                    #
# +++++++++++++++++++++++++++++++++++++++++++++++ #