

resource "azurerm_application_insights" "sh_appinsights" {
  count               = var.use_existing_app_insights ? 0 : 1
  name                = "appi-${var.prefix}-${var.environment}-${var.location}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  application_type    = "web"
}

resource "azurerm_log_analytics_workspace" "sh_log_analytics" {
  count               = var.use_existing_log_analytics ? 0 : 1
  name                = "${var.prefix}-logs-workspace"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}