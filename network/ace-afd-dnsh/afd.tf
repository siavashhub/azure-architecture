# +++++++++++++++++++++++++++++++++++++++++++++++ #
#               Azure Front Door                  #
#                                                 #

# Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "acednsh_afd" {
  name                     = "afdp-${var.workload}-${var.environment_type}-001"
  resource_group_name      = azurerm_resource_group.shared.name
  response_timeout_seconds = 60
  sku_name                 = "Premium_AzureFrontDoor"

  lifecycle {
    ignore_changes = [tags]
  }

  # to help with ACE provisioning state issues
  depends_on = [ 
    azurerm_container_app_environment.ace_2
  ]  
}

# Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "acednsh_afd" {
  name                     = "afde-${var.workload}-${var.environment_type}-001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.acednsh_afd.id

  lifecycle {
    ignore_changes = [tags]
  }

}

# Origin Group for App1
resource "azurerm_cdn_frontdoor_origin_group" "app1" {
  name                     = "afdog-app1-${var.workload}-${var.environment_type}-001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.acednsh_afd.id

  health_probe {
    interval_in_seconds = 100
    path                = "/ping"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

# Origin Group for App2
resource "azurerm_cdn_frontdoor_origin_group" "app2" {
  name                     = "afdog-app2-${var.workload}-${var.environment_type}-001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.acednsh_afd.id

  health_probe {
    interval_in_seconds = 100
    path                = "/ping"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

# Origin for App1
resource "azurerm_cdn_frontdoor_origin" "app1" {
  name                          = "afdo-app1-${var.workload}-${var.environment_type}-001"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.app1.id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name                      = azurerm_container_app.app1_service.ingress[0].fqdn
  origin_host_header             = azurerm_container_app.app1_service.ingress[0].fqdn

  priority = 1
  weight   = 1000

  private_link {
    request_message        = "AFD Private Link Request"
    target_type            = "managedEnvironments"
    location               = azurerm_container_app_environment.ace_1.location
    private_link_target_id = azurerm_container_app_environment.ace_1.id
  }
}

# Origin for App2
resource "azurerm_cdn_frontdoor_origin" "app2" {
  name                          = "afdo-app2-${var.workload}-${var.environment_type}-001"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.app2.id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name                      = azurerm_container_app.app2_service.ingress[0].fqdn
  origin_host_header             = azurerm_container_app.app2_service.ingress[0].fqdn

  priority = 1
  weight   = 1000

  private_link {
    request_message        = "AFD Private Link Request"
    target_type            = "managedEnvironments"
    location               = azurerm_container_app_environment.ace_2.location
    private_link_target_id = azurerm_container_app_environment.ace_2.id
  }

  timeouts {

  }
}

# Custom Domain for App1
resource "azurerm_cdn_frontdoor_custom_domain" "app1" {
  name                     = "app1service-${lower(replace(var.custom_domain_zone_name, ".", "-"))}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.acednsh_afd.id
  host_name                = "app1service.${var.custom_domain_zone_name}"

  tls {
    certificate_type    = "ManagedCertificate"
  }
}

# Custom Domain for App2
resource "azurerm_cdn_frontdoor_custom_domain" "app2" {
  name                     = "app2service-${lower(replace(var.custom_domain_zone_name, ".", "-"))}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.acednsh_afd.id
  host_name                = "app2service.${var.custom_domain_zone_name}"

  tls {
    certificate_type    = "ManagedCertificate"
  }
}

# Route for App1
resource "azurerm_cdn_frontdoor_route" "app1" {
  name                          = "afd-route-app1"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.acednsh_afd.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.app1.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.app1.id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.app1.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  link_to_default_domain = false
  https_redirect_enabled = false
}

# Route for App2
resource "azurerm_cdn_frontdoor_route" "app2" {
  name                          = "afd-route-app2"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.acednsh_afd.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.app2.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.app2.id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.app2.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  link_to_default_domain = false
  https_redirect_enabled = false
}

# Custom Domain Association for App1
resource "azurerm_cdn_frontdoor_custom_domain_association" "app1" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.app1.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.app1.id]
}

# Custom Domain Association for App2
resource "azurerm_cdn_frontdoor_custom_domain_association" "app2" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.app2.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.app2.id]
}
