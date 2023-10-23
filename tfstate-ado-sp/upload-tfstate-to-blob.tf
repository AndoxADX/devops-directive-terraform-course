terraform {

  required_providers {

    azurerm = {

      source = "hashicorp/azurerm"

      version = "3.8.0"

    }

  }

}



provider "azurerm" {

  subscription_id = "<subscription-id>"

  tenant_id = "<tenant-id>"

  client_id = "<client-id>"

  client_secret = "<client-secret>"

  features {}

}



resource "azurerm_resource_group" "appgrp" {

  name = "rg-name"

  location = "North Europe"

}



resource "azurerm_storage_account" "siliconstrg0985" {

  name = "siliconstrg0985"

  resource_group_name = "app-grp"

  location = "North Europe"

  account_tier = "Standard"

  account_replication_type = "LRS"

  account_kind = "StorageV2"

  depends_on = [

    azurerm_resource_group.appgrp

  ]

}



resource "azurerm_storage_container" "data" {

  name = "data"

  storage_account_name = "siliconstrg0985"

  container_access_type = "blob"

  depends_on = [

    azurerm_storage_account.siliconstrg0985

  ]

}



resource "azurerm_storage_blob" "maintf" {

  name = "main.tf"

  storage_account_name = "siliconstrg0985"

  storage_container_name = "data"

  type = "Block"

  source = "main.tf"

  depends_on = [

    azurerm_storage_container.data

  ]

}



terraform {

  backend "azurerm" {

    resource_group_name = "app-grp"

    storage_account_name = "siliconstrg0985"

    container_name = "data"

    key = "terraform.tfstate"

  }

}
