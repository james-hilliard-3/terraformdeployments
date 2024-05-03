terraform {
  required_version = ">= 0.14"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  environment = var.environment  # This now references the declared variable
}
