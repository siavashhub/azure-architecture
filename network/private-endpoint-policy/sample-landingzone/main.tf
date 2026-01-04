locals {
  tags = merge(
    {
      Workload            = var.workload
      Region              = var.location
      Environment         = var.environment_type
      BuiltBy             = "Terraform"
    },
    var.tags
  )
}

resource "random_integer" "storage_suffix" {
  min = 100000
  max = 999999
}

resource "random_string" "default_custom_subdomain_name_suffix" {
  length  = 5
  special = false
  upper   = false
}

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 Resource Groups                 #
#                                                 #

resource "azurerm_resource_group" "ai" {
  location = var.location
  name     = "rg-${var.workload}-ai-${var.environment_type}-${var.region}-01"
  
  tags = local.tags
}

#                                                 #
#              END Resource Groups                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
