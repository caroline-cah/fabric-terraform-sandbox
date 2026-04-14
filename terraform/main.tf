resource "azurerm_resource_group" "fabric_rg" {
  name     = "fabric-iac-${var.environment}-rg"
  location = var.location

  tags = {
    environment = var.environment
    project     = "fabric-iac-playground"
    managed_by  = "terraform"
  }
}

resource "fabric_workspace" "sandbox" {
  display_name = "fabric-iac-${var.environment}"
  description  = "IaC sandbox workspace (${var.environment}) — managed by Terraform"
}
