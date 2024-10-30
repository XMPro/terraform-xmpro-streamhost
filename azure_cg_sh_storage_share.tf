resource "azurerm_storage_share" "sh_data" {
  count = var.create_storage_share ? 1 : 0  # Conditional creation of storage share
  name                 = "share-data"
  storage_account_name = var.storage_account_name
  quota                = 10
  depends_on           = [var.storage_account_name]
}

