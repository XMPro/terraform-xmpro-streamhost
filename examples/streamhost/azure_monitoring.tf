resource "azurerm_application_insights" "sh_appinsights_adex" {
  name                = "appi-${var.prefix}-${var.environment}-${var.location}"
  location            = azurerm_resource_group.xmpro_sh_rg_adex.location
  resource_group_name = azurerm_resource_group.xmpro_sh_rg_adex.name
  application_type    = "web"
}

resource "azurerm_log_analytics_workspace" "sh_log_analytics_adex" {
  name                = "${var.prefix}-logs-workspace"
  location            = azurerm_resource_group.xmpro_sh_rg_adex.location
  resource_group_name = azurerm_resource_group.xmpro_sh_rg_adex.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}