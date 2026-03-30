terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "fabric-iac-state-rg"
    storage_account_name = "fabriciacstate"
    container_name       = "tfstate"
    key                  = "fabric-iac-playground.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}