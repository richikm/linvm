provider "azurerm" {
  version = "2.12.0"
  features {}
}

resource "azurerm_resource_group" "RGTerra" {
name = "RGTerra"
location = var.location
}

