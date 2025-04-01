terraform {
  backend "azurerm" {
    resource_group_name   = "opella"
    storage_account_name  = "axelfulopterraformstate"
    container_name        = "state"
    key                   = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
}

provider "azurerm" {
  features {}
}