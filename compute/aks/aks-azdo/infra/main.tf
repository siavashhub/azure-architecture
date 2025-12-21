locals {
  tags = merge(
    {
      Workload    = var.workload
      Region      = var.location
      Environment = var.environment_type
      BuiltBy     = "Terraform"
    },
    var.tags
  )
}

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 Resource Groups                 #
#                                                 #

resource "azurerm_resource_group" "aks" {
  name     = "rg-${var.prefix}-${var.workload}-aks-${var.environment_type}-${var.region}-01"
  location = var.location

  tags = local.tags

}

resource "azurerm_resource_group" "network" {
  name     = "rg-${var.prefix}-${var.workload}-network-${var.environment_type}-${var.region}-01"
  location = var.location

  tags = local.tags

}

#                                                 #
#              END Resource Groups                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #