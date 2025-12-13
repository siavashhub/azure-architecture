variable "subscription_id" {
  type        = string
  description = "Azure subscription id to deploy resources within"
}

variable "custom_domain_zone_name" {
  type        = string
  description = "Custom domain zone that you own and have valid certificate for to be used for AFD and ACA custom domains"
}

variable "prefix" {
  type        = string
  description = "prefix/id"
  default     = "poc"
}

variable "workload" {
  type        = string
  description = "This variable defines the workload/application/product name"
  default     = "acednsh"
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
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "westus3"
}

variable "region" {
  type        = string
  description = "Azure region shortname (max 4 char lowercase alphanumeric)"
  default     = "wus3"

  validation {
    condition     = length(var.region) <= 4 && can(regex("^[a-z0-9]+$", var.region))
    error_message = "Region must be 1-4 lowercase alphanumeric characters (a-z, 0-9)."
  }
}

variable "container_image" {
  type        = string
  description = "Container image for App services"
  default     = "docker.io/siavashhub/fastapi-ping:latest"
}

variable "network" {
  description = "Object representing network configuration"
  type = object({
    app1_virtual_network_address_space = list(string)
    app2_virtual_network_address_space = list(string)
    app1_subnet_address_space          = list(string)
    app2_subnet_address_space          = list(string)
  })

  default = {
    app1_virtual_network_address_space = ["10.100.11.0/24"]
    app1_subnet_address_space          = ["10.100.11.0/27","10.100.11.32/27"]
    app2_virtual_network_address_space = ["10.200.12.0/24"]
    app2_subnet_address_space          = ["10.200.12.0/27","10.200.12.32/27"]
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional Azure tags for the resources"
  default     = {}
}
