output "location" {
  value = azurerm_resource_group.aks.location
}

output "resource_group_name" {
  value = azurerm_resource_group.aks.name
}

output "versions" {
  value = data.azurerm_kubernetes_service_versions.current.versions
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}

output "alb_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_agfc.client_id
}

output "alb_identity_resource_id" {
  value = azurerm_user_assigned_identity.aks_agfc.id
}