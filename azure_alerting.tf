resource "azurerm_monitor_action_group" "sh_alerts_action_group" {
  count               = var.enable_alerting ? 1 : 0
  name                = "ag-${var.prefix}-${var.location}-sh-alerts"
  resource_group_name = local.resource_group_name
  short_name          = "sh-alerts"

  dynamic "email_receiver" {
    for_each = var.enable_email_alerts && length(var.alert_email_addresses) > 0 ? toset(var.alert_email_addresses) : []
    content {
      name                    = "email-${index(var.alert_email_addresses, email_receiver.value) + 1}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }

  dynamic "sms_receiver" {
    for_each = var.enable_sms_alerts && length(var.alert_phone_numbers) > 0 ? toset(var.alert_phone_numbers) : []
    content {
      name         = "sms-${index(var.alert_phone_numbers, sms_receiver.value) + 1}"
      country_code = var.alert_phone_country_code
      phone_number = sms_receiver.value
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.enable_webhook_alerts && length(var.alert_webhook_urls) > 0 ? toset(var.alert_webhook_urls) : []
    content {
      name                    = "webhook-${index(var.alert_webhook_urls, webhook_receiver.value) + 1}"
      service_uri             = webhook_receiver.value
      use_common_alert_schema = true
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "sh_cpu_alert" {
  count               = var.enable_alerting && var.enable_cpu_alerts ? 1 : 0
  name                = "alert-${var.prefix}-${var.location}-sh-cpu"
  resource_group_name = local.resource_group_name
  scopes              = [azurerm_container_group.streamhost.id]
  description         = "Alert when StreamHost CPU usage exceeds threshold"
  severity            = var.cpu_alert_severity
  window_size         = var.alert_window_size
  frequency           = var.alert_evaluation_frequency

  criteria {
    metric_namespace = "Microsoft.ContainerInstance/containerGroups"
    metric_name      = "CpuUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_alert_threshold * 10 * var.streamhost_cpu
  }

  action {
    action_group_id = azurerm_monitor_action_group.sh_alerts_action_group[0].id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "sh_memory_alert" {
  count               = var.enable_alerting && var.enable_memory_alerts ? 1 : 0
  name                = "alert-${var.prefix}-${var.location}-sh-memory"
  resource_group_name = local.resource_group_name
  scopes              = [azurerm_container_group.streamhost.id]
  description         = "Alert when StreamHost memory usage exceeds threshold"
  severity            = var.memory_alert_severity
  window_size         = var.alert_window_size
  frequency           = var.alert_evaluation_frequency

  criteria {
    metric_namespace = "Microsoft.ContainerInstance/containerGroups"
    metric_name      = "MemoryUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = (var.memory_alert_threshold / 100) * var.streamhost_memory * 1024 * 1024 * 1024 # Convert percentage to bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.sh_alerts_action_group[0].id
  }

  tags = var.tags
}

resource "azurerm_monitor_activity_log_alert" "container_restart_alert" {
  count               = var.enable_alerting && var.enable_container_restart_alerts ? 1 : 0
  name                = "alert-${var.prefix}-${var.location}-sh-container-restart"
  resource_group_name = local.resource_group_name
  location            = "global"
  scopes              = [azurerm_container_group.streamhost.id]
  description         = "Alert when StreamHost container instance restarts"

  criteria {
    resource_id    = azurerm_container_group.streamhost.id
    operation_name = "Microsoft.ContainerInstance/containerGroups/restart/action"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.sh_alerts_action_group[0].id
  }

  tags = var.tags
}

resource "azurerm_monitor_activity_log_alert" "container_stop_alert" {
  count               = var.enable_alerting && var.enable_container_stop_alerts ? 1 : 0
  name                = "alert-${var.prefix}-${var.location}-sh-container-stop"
  resource_group_name = local.resource_group_name
  location            = "global"
  scopes              = [azurerm_container_group.streamhost.id]
  description         = "Alert when StreamHost container instance is stopped"

  criteria {
    resource_id    = azurerm_container_group.streamhost.id
    operation_name = "Microsoft.ContainerInstance/containerGroups/stop/action"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.sh_alerts_action_group[0].id
  }

  tags = var.tags
}
