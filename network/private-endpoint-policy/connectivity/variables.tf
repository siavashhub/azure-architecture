variable "subscription_id" {
  type = string
  description = "Azure subscription id to deploy resources within"
}

variable "top_level_management_group_display_name" {
  type        = string
  description = "Top Level Management Group Display Name for Policy Assignment Scope"
}

variable "mgprefix" {
  type = string
  description = "Root management group prefix/id"
  default = "sbx"
}

variable "workload" {
  type = string
  description = "This variable defines the workload/platform name"
  default = "connectivity"
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
  description = "Azure region shortname convention (max 4 char)"
  default = "wus"

  validation {
    condition     = length(var.region) <= 4 && can(regex("^[a-z0-9]+$", var.region))
    error_message = "Region must be 1-4 lowercase alphanumeric characters (a-z, 0-9)."
  }      
}

variable "geo" {
  type = string
  description = "Azure geolocation shortname convention (max 4 char)"
  default = "na"
}

variable "tags" {
  type        = map(string)
  description = "Additional Azure tags for the resources"
  default     = {}
}

variable "deny_prive_dns_zone_creation" {
  type = bool
  default = false
}
