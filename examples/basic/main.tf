terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}  # This empty features block is required

  tenant_id       = ""
  subscription_id = ""
}

module "xmpro" {
  source = "../../"

  prefix      = "acme"
  location    = "centralus"

  ds_server_url                = ""
  streamhost_collection_id     = ""
  streamhost_collection_secret = ""
  
}