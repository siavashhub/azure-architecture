# +++++++++++++++++++++++++++++++++++++++++++++++ #
#                   AKS Cluster                   #
#                                                 #

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                  = "aks-${var.workload}-${var.environment_type}-${var.region}-01"
  location              = azurerm_resource_group.aks.location
  resource_group_name   = azurerm_resource_group.aks.name
  dns_prefix            = "${var.workload}-${var.environment_type}-${var.region}"
  kubernetes_version    = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group   = "rg-${var.prefix}-${var.workload}-nodes-${var.environment_type}-${var.region}-01"
  sku_tier              = var.aks_sku_tier
  azure_policy_enabled  = true
  oidc_issuer_enabled   = true

  default_node_pool {
    name                 = "systempool"
    vm_size              = var.system_node_pool_vm_size
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    auto_scaling_enabled = true
    max_count            = 2
    min_count            = 1
    os_sku               = "Ubuntu"
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id        = azurerm_subnet.aks_nodes.id
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "${var.environment_type}"
      "nodepools"        = "linux"
      "app"              = "system-apps"
    }
    tags = {
      "nodepool-type"    = "system"
      "environment"      = "${var.environment_type}"
      "nodepools"        = "linux"
      "app"              = "system-apps"
    }
    temporary_name_for_rotation = "tmpnodepool1"
  }

  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  azure_active_directory_role_based_access_control {
      azure_rbac_enabled = true
      admin_group_object_ids = [data.azuread_group.aks_admins.object_id]
  }

  # Linux Profile
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  # Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [tags]
  }  
}

#                                                 #
#                  END AKS Cluster                #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
