
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

  app1_service_name       = "app1service"
  app2_service_name       = "app2service"
}

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 Resource Groups                 #
#                                                 #

resource "azurerm_resource_group" "shared" {
  name     = "rg-${var.prefix}-${var.workload}-shared-${var.environment_type}-${var.region}-001"
  location = var.location

  tags = local.tags
}

resource "azurerm_resource_group" "ace_1_app" {
  name     = "rg-${var.prefix}-${var.workload}-app-${var.environment_type}-${var.region}-001"
  location = var.location

  tags = local.tags
}

resource "azurerm_resource_group" "ace_2_app" {
  name     = "rg-${var.prefix}-${var.workload}-app-${var.environment_type}-${var.region}-002"
  location = var.location

  tags = local.tags
}

#                                                 #
#              END Resource Groups                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #