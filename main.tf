variable "resource_group" {
  default = "spike-tf-rg"
  description = "The name of the resource group to create"
}

variable "resource_group_location" {
  default = "westus"
  description = "The location of the resource group to create"
}

variable "app_service_plan_name" {
  default = "spike-tf-asp"
  description = "The name of the app service plan to create"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "spike-tf-storage-rg"
    storage_account_name = "spiketfsa"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "tailspin" {
  name     = "${var.resource_group}"
  location = "${var.resource_group_location}"
}

resource "azurerm_app_service_plan" "tailspin" {
  name                = "${var.app_service_plan_name}-asp"
  location            = "${azurerm_resource_group.tailspin.location}"
  resource_group_name = "${azurerm_resource_group.tailspin.name}"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "FREE"
    size = "F1"
  }
}

resource "azurerm_app_service" "tailspin" {
  name                = "${var.app_service_plan_name}-appservice"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group}"
  app_service_plan_id = "${azurerm_app_service_plan.tailspin.id}"
}
