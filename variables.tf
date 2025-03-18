variable "prefix" {
  description = "The prefix used for all resources in this example, we recommend using your company name"
  type        = string
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-xmpro-sh-default-australiaeast"
}

locals {
  resource_group_name_warning = can(regex("^rg-", var.resource_group_name)) ? "" : "WARNING: Resource group name should start with \"rg-\""
}

output "warnings" {
  value = compact([local.resource_group_name_warning])
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
  default     = "australiaeast"
  validation {
    condition = contains([
      "eastus", "eastus2", "southcentralus", "westus2", "westus3", "australiaeast",
      "southeastasia", "northeurope", "swedencentral", "uksouth", "westeurope",
      "centralus", "southafricanorth", "centralindia", "eastasia", "japaneast",
      "koreacentral", "canadacentral", "francecentral", "germanywestcentral",
      "norwayeast", "switzerlandnorth", "uaenorth", "brazilsouth", "centralusstage",
      "eastusstage", "eastus2stage", "northcentralus", "westus", "japanwest",
      "jioindiawest", "westcentralus", "southafricawest", "australiacentral",
      "australiacentral2", "australiasoutheast", "japannorth", "koreasouth",
      "southindia", "westindia", "canadaeast", "francesouth", "germanynorth",
      "norwaywest", "switzerlandwest", "ukwest", "uaecentral", "brazilsoutheast"
    ], var.resource_group_location)
    error_message = "Must use an available Azure location. See https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  }
}

#-----------------------
# Azure Container Registry information
#-----------------------

variable "acr_url" {
  description = "The URL of the Azure Container Registry"
  type        = string
  default     = "xmpro.azurecr.io"
}

variable "acr_username" {
  description = "The username of the Azure Container Registry"
  type        = string
  default     = "xmpro"
}

variable "acr_password" {
  description = "The password of the Azure Container Registry"
  type        = string
  sensitive   = true
  default     = "none"
}

#-----------------------
# Streamhost information
#-----------------------

variable "streamhost_name" {
  description = "The name of the stream host"
  type        = string
  default     = ""
}

variable "ds_server_url" {
  description = "The URL of the datastream host server (e.g., https://example.com)"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^https?://", var.ds_server_url))
    error_message = "The ds_server_url must be a valid HTTP/HTTPS URL."
  }
}

variable "streamhost_collection_id" {
  description = "The collection ID of the stream host"
  type        = string
  sensitive   = true
}

variable "streamhost_collection_secret" {
  description = "The collection secret of the stream host"
  type        = string
  sensitive   = true
}

variable "appinsights_connectionstring" {
  description = "The connection string of the application insights"
  type        = string
  sensitive   = true
  default     = ""
}

variable "streamhost_cpu" {
  description = "The CPU of the stream host"
  type        = number
  default     = 1
  validation {
    condition     = var.streamhost_cpu >= 0.5 && var.streamhost_cpu <= 4
    error_message = "CPU must be between 0.5 and 4 cores."
  }
}

variable "streamhost_memory" {
  description = "The memory of the stream host"
  type        = number
  default     = 4
  validation {
    condition     = var.streamhost_memory >= 1 && var.streamhost_memory <= 16
    error_message = "Memory must be between 1 and 16 GB."
  }
}

variable "streamhost_container_image_base" {
  description = "The base docker container image (without tag) to be used by the stream host"
  default     = "xmprononprod.azurecr.io/stream-host"
  type        = string
}

variable "streamhost_container_image_tags" {
  description = "The docker container image tag(s) specifying the version and variant of the stream host"
  type        = list(string)
  default     = ["latest"]
}

variable "log_analytics_id" {
  description = "This variable holds the ID of the Log Analytics workspace"
  type        = string
  default     = ""
}

variable "log_analytics_primary_shared_key" {
  description = "This variable holds the primary shared key for the Log Analytics workspace"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "The environment variables of the stream host"
  type        = map(string)
  default     = {}
}

variable "volumes" {
  description = "List of volumes to be mounted"
  type = list(object({
    name                 = string
    mount_path           = string
    read_only            = optional(bool, false)
    share_name           = string
    storage_account_name = string
    storage_account_key  = string
  }))
  default = []
}

variable "use_existing_storage_account" {
  description = "set to true to use an existing storage account share, false to create a new one"
  type        = bool
  default     = false
}

variable "use_existing_app_insights" {
  description = "set to true to use an existing application insights, false to create a new one"
  type        = bool
  default     = false
}

variable "use_existing_log_analytics" {
  description = "set to true to use an existing log analytics workspace, false to create a new one"
  type        = bool
  default     = false
}

variable "use_existing_rg" {
  description = "set to true to use an existing resource group, false to create a new one"
  type        = bool
  default     = false
}

# ------------------ Application Insights ------------------
variable "appinsights_minimum_level_default" {
  description = "The minimum logging level for Application Insights"
  type        = string
  default     = "Information"

  validation {
    condition     = contains(["Trace", "Debug", "Information", "Warning", "Error", "Critical", "None"], var.appinsights_minimum_level_default)
    error_message = "The minimum logging level must be one of: Trace, Debug, Information, Warning, Error, Critical, or None."
  }
}

#-----------------------
# Tags
#-----------------------

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

#-----------------------
# Monitoring Configuration
#-----------------------

variable "enable_monitoring" {
  description = "Master switch to enable or disable all monitoring resources"
  type        = bool
  default     = true
}

variable "enable_app_insights" {
  description = "Enable Application Insights monitoring"
  type        = bool
  default     = true
}

variable "enable_log_analytics" {
  description = "Enable Log Analytics workspace"
  type        = bool
  default     = true
}

variable "enable_app_insights_telemetry" {
  description = "Enable Application Insights telemetry collection (requires app insights to be enabled)"
  type        = bool
  default     = true
}

#-----------------------
# Alerting Configuration
#-----------------------

variable "enable_alerting" {
  description = "Master switch to enable or disable all alerting resources"
  type        = bool
  default     = true
}

# CPU Alerting
variable "enable_cpu_alerts" {
  description = "Enable CPU usage alerting"
  type        = bool
  default     = true
}

variable "cpu_alert_threshold" {
  description = "Threshold for CPU usage alerts (percentage)"
  type        = number
  default     = 80
  validation {
    condition     = var.cpu_alert_threshold > 0 && var.cpu_alert_threshold <= 100
    error_message = "CPU alert threshold must be between 1 and 100 percent."
  }
}

variable "cpu_alert_severity" {
  description = "Severity level for CPU alerts (0-4, where 0 is critical)"
  type        = number
  default     = 2
  validation {
    condition     = var.cpu_alert_severity >= 0 && var.cpu_alert_severity <= 4
    error_message = "Severity must be between 0 (critical) and 4 (verbose)."
  }
}

# Memory Alerting
variable "enable_memory_alerts" {
  description = "Enable memory usage alerting"
  type        = bool
  default     = true
}

variable "memory_alert_threshold" {
  description = "Threshold for memory usage alerts (percentage)"
  type        = number
  default     = 80
  validation {
    condition     = var.memory_alert_threshold > 0 && var.memory_alert_threshold <= 100
    error_message = "Memory alert threshold must be between 1 and 100 percent."
  }
}

variable "memory_alert_severity" {
  description = "Severity level for memory alerts (0-4, where 0 is critical)"
  type        = number
  default     = 2
  validation {
    condition     = var.memory_alert_severity >= 0 && var.memory_alert_severity <= 4
    error_message = "Severity must be between 0 (critical) and 4 (verbose)."
  }
}

# Container Restart Alerting
variable "enable_container_restart_alerts" {
  description = "Enable container restart alerting"
  type        = bool
  default     = true
}

# Container Stop Alerting
variable "enable_container_stop_alerts" {
  description = "Enable container stop alerting"
  type        = bool
  default     = true
}

# General Alert Settings
variable "alert_window_size" {
  description = "The time window for metric alerts (ISO 8601 duration format)"
  type        = string
  default     = "PT5M" # 5 minutes
}

variable "alert_evaluation_frequency" {
  description = "The evaluation frequency for metric alerts (ISO 8601 duration format)"
  type        = string
  default     = "PT1M" # 1 minute
}

# Email Alert Configuration
variable "enable_email_alerts" {
  description = "Enable email notifications for alerts"
  type        = bool
  default     = false
}

variable "alert_email_addresses" {
  description = "List of email addresses to receive alert notifications"
  type        = list(string)
  default     = []
}

# SMS Alert Configuration
variable "enable_sms_alerts" {
  description = "Enable SMS notifications for alerts"
  type        = bool
  default     = false
}

variable "alert_phone_numbers" {
  description = "List of phone numbers to receive SMS alert notifications"
  type        = list(string)
  default     = []
}

variable "alert_phone_country_code" {
  description = "Country code for SMS alert phone numbers"
  type        = string
  default     = "1" # US country code
}

# Webhook Alert Configuration
variable "enable_webhook_alerts" {
  description = "Enable webhook notifications for alerts"
  type        = bool
  default     = false
}

variable "alert_webhook_urls" {
  description = "List of webhook URLs to receive alert notifications"
  type        = list(string)
  default     = []
}

#-----------------------
# Outputs
#-----------------------

# Container Group Outputs
output "container_group_id" {
  description = "The ID of the container group"
  value       = azurerm_container_group.streamhost.id
}

# Monitoring Outputs
output "app_insights_instrumentation_key" {
  description = "The instrumentation key for Application Insights"
  value       = local.effective_enable_app_insights ? (var.use_existing_app_insights ? var.appinsights_connectionstring : try(azurerm_application_insights.sh_appinsights[0].instrumentation_key, null)) : null
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "The connection string for Application Insights"
  value       = local.app_insights_conn_string
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "The workspace ID for Log Analytics"
  value       = local.log_analytics_id
}

# Resource Group Outputs (conditional)
output "resource_group_id" {
  description = "The ID of the resource group (if created by this module)"
  value       = var.use_existing_rg ? null : try(azurerm_resource_group.xmpro_sh_rg[0].id, null)
}

output "resource_group_name" {
  description = "The name of the resource group used by this module"
  value       = local.resource_group_name
}

# StreamHost Outputs
output "streamhost_name" {
  description = "The name of the StreamHost instance"
  value       = local.sh_name
}
