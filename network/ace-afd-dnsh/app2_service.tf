# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                  Container App                  #
#                                                 #
resource "azurerm_container_app" "app2_service" {
  name                         = "ca-${local.app2_service_name}-${var.environment_type}-${var.region}-001"
  container_app_environment_id = azurerm_container_app_environment.ace_2.id
  resource_group_name          = azurerm_resource_group.ace_2_app.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name  = local.app2_service_name
      image = var.container_image

      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "Region"
        value = var.region
      }
      env {
        name  = "Environment"
        value = var.environment_type
      }
      env {
        name  = "Workload"
        value = var.workload
      }
      env {
        name  = "APP_NAME"
        value = local.app2_service_name
      }

      liveness_probe {
        port      = 80
        transport = "TCP"
        timeout   = 20
      }

      startup_probe {
        port      = 80
        transport = "TCP"
        timeout   = 20
      }

      readiness_probe {
        port      = 80
        transport = "TCP"
        timeout   = 20
      }

    }

    min_replicas = 1
    max_replicas = 1
  }

  lifecycle {
    ignore_changes = [tags]
  }

  # to help with ACE provisioning state issues
  depends_on = [ azurerm_cdn_frontdoor_origin.app1 ]
}

#                                                 #
#                END Container App                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                  Custom Domain                  #
#                                                 #

resource "azurerm_container_app_custom_domain" "app2_service" {
  name              = "${local.app2_service_name}.${var.custom_domain_zone_name}"
  container_app_id  = azurerm_container_app.app2_service.id
  certificate_binding_type = "Disabled"

}

#                                                 #
#                END Custom Domain                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #