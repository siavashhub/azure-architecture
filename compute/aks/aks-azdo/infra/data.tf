data "azurerm_subscription" "current" {}

data "azuread_group" "aks_admins" {
  display_name     = var.aks_admin_group
  security_enabled = true
}

data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.aks.location
  include_preview = false
}
