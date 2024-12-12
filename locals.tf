locals {
    sh_name                          = var.streamhost_name == "" ? "sh-01-tfaci-default-${var.environment}-${var.location}" : var.streamhost_name

    resource_group_name              = var.use_existing_rg ? var.resource_group_name : azurerm_resource_group.xmpro_sh_rg[0].name
    resource_group_location          = var.use_existing_rg ? var.resource_group_location : azurerm_resource_group.xmpro_sh_rg[0].location

    log_analytics_id                 = var.use_existing_log_analytics ? var.log_analytics_id : azurerm_log_analytics_workspace.sh_log_analytics[0].workspace_id
    log_analytics_primary_shared_key = var.use_existing_log_analytics ? var.log_analytics_primary_shared_key : azurerm_log_analytics_workspace.sh_log_analytics[0].primary_shared_key

    app_insights_conn_string         = var.use_existing_app_insights ? var.appinsights_connectionstring : azurerm_application_insights.sh_appinsights[0].connection_string
}