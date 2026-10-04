location            = "Australia East"
resource_group_name = "koalatech-week08-rg"

# Replace with a unique name for your Azure Container Registry 
acr_name = "sit722terraformacr09"

# Replace with a unique name for your Azure Storage Account
storage_account_name = "sit722task93cangal1004"

# Replace with a unique name for your Azure Kubernetes Service cluster
aks_cluster_name = "sit722akscluster09"
aks_dns_prefix   = "koalatech"

aks_node_count   = 3
aks_node_vm_size = "Standard_D2als_v6"

environment = "development"

tags = {
  Project     = "KoalaTech Course Platform"
  ManagedBy   = "Terraform"
  Practical   = "Week08"
  Environment = "Development"
}

# Two system nodes plus one application node: three nodes in total.
aks_system_node_count   = 2
aks_system_node_vm_size = "Standard_D4als_v6"
