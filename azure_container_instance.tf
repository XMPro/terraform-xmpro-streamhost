
resource "azurerm_resource_group" "xmpro_sh_rg" {
  count = var.use_existing_rg ? 0 : 1
  name     = "rg-sh-${var.prefix}-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Created_For    = "XMPRO ${var.environment} Streamhost"
    Created_By     = "sh-default-admin"
    Keep_or_delete = "Keep"
  }
}

