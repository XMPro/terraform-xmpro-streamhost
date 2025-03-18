resource "azurerm_log_analytics_workspace" "sh_log_analytics" {
  count               = local.effective_enable_log_analytics && !var.use_existing_log_analytics ? 1 : 0
  name                = "log-${var.prefix}-${var.location}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "sh_appinsights" {
  workspace_id        = local.effective_enable_log_analytics ? (var.use_existing_log_analytics ? (var.log_analytics_id != "" ? var.log_analytics_id : null) : azurerm_log_analytics_workspace.sh_log_analytics[0].id) : null
  count               = local.effective_enable_app_insights && !var.use_existing_app_insights ? 1 : 0
  name                = "appi-${var.prefix}-${var.location}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  application_type    = "web"
  tags                = var.tags
}
