terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.117.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0.6"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "tls" {}
