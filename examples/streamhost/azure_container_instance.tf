
resource "azurerm_resource_group" "xmpro_sh_rg_adex" {
  name     = "rg-${var.prefix}-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Created_For    = "xmpro ${var.environment} advance streamhost example"
    Created_By     = "sh-default-admin"
    Keep_or_delete = "Keep"
  }
}

