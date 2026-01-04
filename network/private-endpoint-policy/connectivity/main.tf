locals {
  tags = merge(
    {
      Workload            = var.workload
      Region              = var.location
      Geo                 = var.geo
      Environment         = var.environment_type
      BuiltBy             = "Terraform"
    },
    var.tags
  )
}


resource "random_id" "dns_zone_policy" {
  for_each    = local.private_dns_zones_policy
  byte_length = 16
}

resource "random_id" "deny_private_dns_zones_id" {
  count = var.deny_prive_dns_zone_creation ? 1 : 0
  byte_length = 16
}

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 Resource Groups                 #
#                                                 #

resource "azurerm_resource_group" "connectivity_primary_dns" {
  name     = "rg-${var.mgprefix}-${var.workload}-dns-${var.environment_type}-${var.region}-01"
  location = var.location

 tags = local.tags
}

#                                                 #
#              END Resource Groups                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
