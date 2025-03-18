locals {
  sh_name = var.streamhost_name == "" ? "${var.prefix}-${var.location}-sh-01" : var.streamhost_name

  resource_group_name     = var.use_existing_rg ? var.resource_group_name : azurerm_resource_group.xmpro_sh_rg[0].name
  resource_group_location = var.use_existing_rg ? var.resource_group_location : azurerm_resource_group.xmpro_sh_rg[0].location

  # Join the array of tags with a colon for the Docker image tag format
  streamhost_container_image_with_version = "${var.streamhost_container_image_base}:${length(var.streamhost_container_image_tags) > 0 ? var.streamhost_container_image_tags[0] : "latest"}"

  # If enable_monitoring is false, force child monitoring settings to false
  effective_enable_app_insights           = var.enable_monitoring ? var.enable_app_insights : false
  effective_enable_log_analytics          = var.enable_monitoring ? var.enable_log_analytics : false
  effective_enable_app_insights_telemetry = var.enable_monitoring ? var.enable_app_insights_telemetry : false

  # Use effective variables for resource creation decisions
  log_analytics_id = local.effective_enable_log_analytics ? (var.use_existing_log_analytics ? var.log_analytics_id : try(azurerm_log_analytics_workspace.sh_log_analytics[0].workspace_id, null)) : null

  log_analytics_primary_shared_key = local.effective_enable_log_analytics ? (var.use_existing_log_analytics ? var.log_analytics_primary_shared_key : try(azurerm_log_analytics_workspace.sh_log_analytics[0].primary_shared_key, null)) : null

  app_insights_conn_string = local.effective_enable_app_insights ? var.use_existing_app_insights ? var.appinsights_connectionstring : try(azurerm_application_insights.sh_appinsights[0].connection_string, null) : null

  enable_alerting_resources = var.enable_alerting && (var.enable_email_alerts || var.enable_sms_alerts || var.enable_webhook_alerts)
  app_insights_id           = local.effective_enable_app_insights ? (var.use_existing_app_insights ? null : try(azurerm_application_insights.sh_appinsights[0].id, null)) : null
}