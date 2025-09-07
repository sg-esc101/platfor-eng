terraform {
  backend "azurerm" {
    resource_group_name  = "remote-backend"
    storage_account_name = "remotebackendstorage"
    container_name       = "statefilekeeper"
    key                  = "terraform.tfstate"
  }
}
