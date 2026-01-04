variable "subscription_id" {
  type = string
  description = "Azure subscription id to deploy resources within"
}

variable "workload" {
  type        = string
  description = "This variable defines the workload/application name"
  default     = "pemgmt"

  validation {
    condition     = length(var.workload) <= 6
    error_message = "The workload name must be 6 characters or less."
  }
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

variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "westus"
}

variable "region" {
  type = string
  description = "Azure region shortname (max 4 char)"
  default = "wus"

  validation {
    condition     = length(var.region) <= 4 && can(regex("^[a-z0-9]+$", var.region))
    error_message = "Region must be 1-4 lowercase alphanumeric characters (a-z, 0-9)."
  }  
}

variable "custom_subdomain_name" {
  type        = string
  default     = null
  description = "(Optional) The subdomain name used for token-based authentication. This property is required when `network_acls` is specified. Changing this forces a new resource to be created."
}

variable "network" {
  description = "Object representing network configuration"
  type = object({
    virtual_network_address_space = list(string)
    subnet_address_space          = list(string)
  })

  default = {
    virtual_network_address_space = ["10.10.250.0/24"]
    subnet_address_space          = ["10.10.250.0/27"]
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional Azure tags for the resources"
  default     = {}
}

