variable "subscription_id" {
  type        = string
  description = "Azure subscription id to deploy resources within"
}

variable "aks_admin_group" {
  type        = string
  description = "Entra ID group name for AKS administrators"
}

variable "ssh_public_key" {
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"
  default     = "~/.ssh/aks-sshkeys/aks-cluster.pub"
}

variable "prefix" {
  type        = string
  description = "prefix/id"
  default     = "poc"
}

variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "northcentralus"
}

variable "environment_type" {
  type        = string
  description = "General type of the environment (nonprod, prod, sandbox)"
  default     = "sandbox"

  validation {
    condition     = contains(["nonprod", "prod", "sandbox"], var.environment_type)
    error_message = "Valid values for var: environment_type are (nonprod, prod, sandbox)."
  }
}

variable "region" {
  type        = string
  description = "Azure region shortname (max 4 char lowercase alphanumeric)"
  default     = "ncus"

  validation {
    condition     = length(var.region) <= 4 && can(regex("^[a-z0-9]+$", var.region))
    error_message = "Region must be 1-4 lowercase alphanumeric characters (a-z, 0-9)."
  }
}

variable "workload" {
  type        = string
  description = "This variable defines the Application"
  default     = "aksagfc"
}

variable "network" {
  description = "Object representing network configuration"
  type = object({
    aks_virtual_network_address_space = list(string)
    aks_subnet_address_space          = list(string)
  })

  default = {
    aks_virtual_network_address_space = ["172.16.240.0/23"]
    aks_subnet_address_space          = ["172.16.240.0/24", "172.16.241.0/24"]
  }
}

variable "system_node_pool_vm_size" {
  type        = string
  description = "VM size for the system node pool in AKS cluster"
  default     = "Standard_B2als_v2"
}

variable "system_node_min_count" {
  type        = number
  description = "Minimum node count for the system node pool in AKS cluster"
  default     = 2
}

variable "system_node_max_count" {
  type        = number
  description = "Maximum node count for the system node pool in AKS cluster"
  default     = 2
}

variable "aks_sku_tier" {
  type        = string
  description = "SKU tier for the AKS cluster"
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.aks_sku_tier)
    error_message = "Valid values for var: aks_sku_tier are (Free, Standard)."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional Azure tags for the resources"
  default = {}
}