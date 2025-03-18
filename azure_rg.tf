resource "azurerm_resource_group" "xmpro_sh_rg" {
  count    = var.use_existing_rg ? 0 : 1
  name     = "rg-xmpro-sh-${var.prefix}-${var.location}"
  location = var.location
  tags     = var.tags
}
