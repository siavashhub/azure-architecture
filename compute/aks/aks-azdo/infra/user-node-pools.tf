# +++++++++++++++++++++++++++++++++++++++++++++++ #
#             AKS User Node Pool                  #
#                                                 #

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool_01" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  mode                  = "User"
  name                  = var.user_node_pool_name
  vm_size               = var.user_node_pool_vm_size
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  auto_scaling_enabled   = true
  max_count            = 2
  min_count            = 0
  os_sku                = "Ubuntu"
  os_type               = "Linux"
  priority              = "Regular"
  vnet_subnet_id        = azurerm_subnet.aks_nodes.id
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment_type
    "nodepoolos"    = "linux"
    "app"           = var.user_node_pool_name
  }

  node_taints = [
    "azure-devops=scaled-agent:NoSchedule"
  ]    

  tags = merge(
    {
      "nodepool-type" = "user"
      "nodepoolos"    = "linux"
      "app"           = var.user_node_pool_name
    },
    local.tags
  )

  lifecycle {
    ignore_changes = [tags]
  }  
}

#                                                 #
#             END AKS User Node Pool              #
# +++++++++++++++++++++++++++++++++++++++++++++++ #

