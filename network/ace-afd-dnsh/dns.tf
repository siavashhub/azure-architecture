# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                   Public DNS                    #
#                                                 #

# Custom Public DNS Zone
resource "azurerm_dns_zone" "custom" {
  name                = var.custom_domain_zone_name
  resource_group_name = azurerm_resource_group.shared.name

  lifecycle {
    ignore_changes = [tags]
  }
}

# CNAME Records for Apps
resource "azurerm_dns_cname_record" "app1_afd" {
  name                = local.app1_service_name
  zone_name           = azurerm_dns_zone.custom.name
  resource_group_name = azurerm_resource_group.shared.name
  ttl                 = 300
  record              = azurerm_cdn_frontdoor_endpoint.acednsh_afd.host_name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_cname_record" "app2_afd" {
  name                = local.app2_service_name
  zone_name           = azurerm_dns_zone.custom.name
  resource_group_name = azurerm_resource_group.shared.name
  ttl                 = 300
  record              = azurerm_cdn_frontdoor_endpoint.acednsh_afd.host_name

  lifecycle {
    ignore_changes = [tags]
  }
}

# TXT Records for AFD Custom Domain Validation
resource "azurerm_dns_txt_record" "app1_afd" {
  name                = join(".", ["_dnsauth", "${local.app1_service_name}"])
  zone_name           = azurerm_dns_zone.custom.name
  resource_group_name = azurerm_resource_group.shared.name
  ttl                 = 300

  record {
    value = azurerm_cdn_frontdoor_custom_domain.app1.validation_token
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_dns_txt_record" "app2_afd" {
  name                = join(".", ["_dnsauth", "${local.app2_service_name}"])
  zone_name           = azurerm_dns_zone.custom.name
  resource_group_name = azurerm_resource_group.shared.name
  ttl                 = 300

  record {
    value = azurerm_cdn_frontdoor_custom_domain.app2.validation_token
  }

  lifecycle {
    ignore_changes = [tags]
  }
}


#                                                 #
#                END Public DNS                   #
# +++++++++++++++++++++++++++++++++++++++++++++++ #


# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                   Private DNS                   #
#                                                 #

# Custom Private DNS Zone
resource "azurerm_private_dns_zone" "custom" {
  name                = var.custom_domain_zone_name
  resource_group_name = azurerm_resource_group.shared.name

  lifecycle {
    ignore_changes = [tags]
  }
}

# Links to VNETs
resource "azurerm_private_dns_zone_virtual_network_link" "custom_ace_1" {
  name                  = "dnslink-custom-${azurerm_virtual_network.ace_1.name}"
  resource_group_name   = azurerm_resource_group.shared.name
  private_dns_zone_name = azurerm_private_dns_zone.custom.name
  virtual_network_id    = azurerm_virtual_network.ace_1.id
  registration_enabled  = true

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "custom_ace_2" {
  name                  = "dnslink-custom-${azurerm_virtual_network.ace_2.name}"
  resource_group_name   = azurerm_resource_group.shared.name
  private_dns_zone_name = azurerm_private_dns_zone.custom.name
  virtual_network_id    = azurerm_virtual_network.ace_2.id
  registration_enabled  = true

  lifecycle {
    ignore_changes = [tags]
  }
}

# A Records for Apps
resource "azurerm_private_dns_a_record" "custom_app_1" {
  zone_name           = azurerm_private_dns_zone.custom.name
  resource_group_name = azurerm_private_dns_zone.custom.resource_group_name

  name    = "app1service"
  ttl     = 60
  records = [azurerm_container_app_environment.ace_1.static_ip_address]

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_private_dns_a_record" "custom_app_2" {
  zone_name           = azurerm_private_dns_zone.custom.name
  resource_group_name = azurerm_private_dns_zone.custom.resource_group_name

  name    = "app2service"
  ttl     = 60
  records = [azurerm_container_app_environment.ace_2.static_ip_address]

  lifecycle {
    ignore_changes = [tags]
  }

}

#                                                 #
#                END Private DNS                  #
# +++++++++++++++++++++++++++++++++++++++++++++++ #