
resource "azurerm_storage_account" "storage_account" {
  resource_group_name = azurerm_resource_group.xmpro_sh_rg_adex.name
  location            = azurerm_resource_group.xmpro_sh_rg_adex.location

  name = "st${var.prefix}${var.environment}001"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

}

resource "azurerm_storage_share" "sh_data" {
  name                 = "share-data"
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = 10
  depends_on           = [azurerm_storage_account.storage_account]
}
