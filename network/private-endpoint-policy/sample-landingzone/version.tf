terraform {
  required_version = ">= 1.10.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.55.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.6.3"
    }
  }
}

# Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

