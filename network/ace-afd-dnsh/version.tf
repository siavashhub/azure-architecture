terraform {
  required_version = ">= 1.10.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.55.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "= 2.8.0"
    }
  }
}

# Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}
