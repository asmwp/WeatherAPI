terraform {
  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "hashicorp/azurerm"
      version = "~> 2.12"
    }
  }
    backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstateac6jx"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_arg" {
    name = "tfmainrg"
    location = "uksouth"
}

resource "azurerm_container_group" "tf_acg" {
    name = "weatherapi"
    location = azurerm_resource_group.tf_arg.location
    resource_group_name = azurerm_resource_group.tf_arg.name

    ip_address_type     = "public"
    dns_name_label      = "reggiemacwa"
    os_type             = "linux"

    container {
        name            = "weatherapi"
        image           = "reggiemac/weatherapi"
        cpu             = 1
        memory          = 1

        ports {
            port        = 80
            protocol    = "TCP"
        }
    }
}