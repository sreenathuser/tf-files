#mapping storage account for state-file
terraform {
  backend "azurerm" {
    resource_group_name   = "logicappstateRG"
    storage_account_name  = "logicappsac"
    container_name        = "terraform-state"
    key                   = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.53.0"
    features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "RG-for-logicapp" {
    name     = "RG-for-logicapp"
    location = "eastus"

    tags = {
        environment = "LogicTFdeploy"
    }
}

resource "azurerm_template_deployment" "my_logic_app" {
    name = "DSGlogicapp"
    resource_group_name = azurerm_resource_group.RG-for-logicapp.name
    template_body = file("/home/runner/work/demo_logic_app/demo_logic_app/template.json")
    parameters_body = file("/home/runner/work/demo_logic_app/demo_logic_app/parameters.json")
    deployment_mode = "Incremental" 
}
