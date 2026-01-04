locals {
  # Mapping is done based on this doc : https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
  private-zones-mapping-data = jsondecode(file("${path.module}/lib/private-zones.json"))

  private_dns_zones = toset(
    distinct(
      flatten(
        [for zoneName in local.private-zones-mapping-data.private-zones-mapping : zoneName.privateDnsZoneName]
      )
    )
  )

  private_dns_zones_policy = {
    for zoneMapping in local.private-zones-mapping-data.private-zones-mapping : "${zoneMapping.privateLinkResourceType}/${zoneMapping.subresource}" => {
      zones                = zoneMapping.privateDnsZoneName
      privateLinkServiceId = zoneMapping.privateLinkResourceType
      groupId              = zoneMapping.subresource
    }
  }
}

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                 Private DNS Zones               #
#                                                 #

resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = local.private_dns_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.connectivity_primary_dns.name
}

#                                                 #
#           END Private DNS Zones                 #
# +++++++++++++++++++++++++++++++++++++++++++++++ #