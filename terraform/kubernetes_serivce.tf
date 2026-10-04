resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free"

  default_node_pool {
    name            = "default"
    node_count      = var.aks_system_node_count
    vm_size         = var.aks_system_node_vm_size
    os_disk_size_gb = 32

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

#
# Grant AKS permission to pull images from your ACR
#
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
# Keep three nodes in total within the subscription's 10-vCPU quota.
# Smaller application nodes fit the remaining quota alongside the system nodes.
resource "azurerm_kubernetes_cluster_node_pool" "application" {
  name                  = "apps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.aks_node_vm_size
  node_count            = var.aks_node_count - var.aks_system_node_count
  mode                  = "User"
  os_disk_size_gb       = 32

  upgrade_settings {
    max_surge = "10%"
  }

  tags = merge(var.tags, { Environment = var.environment })
}
