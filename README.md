# XMPro - Streamhost Terraform Module

## Overview
This Terraform module provides a configuration for deploying resources on Azure using Terraform CLI Commands. It includes customizable variables for resource naming, environment specifications, and resource allocations.

## Prerequisites:
* Terraform CLI
* Shell to run CLI (PowerShell or Bash/etc)
* IDE: VSCode (optional)

## Usage:

### 1. Copy paste into your terraform directory

```
    module "streamhost" {
        source  = "XMPro/streamhost/xmpro"
        version = "0.0.5"
        # insert the 5 required variables here
    }
```

### 2. Configure required parameters in `main.tf`

Inside of the directory where your root module is located, update security-sensitive and other required variables:

| Property                       | Description                                                               |
| ------------------------------ | ------------------------------------------------------------------------- |
| `prefix`                       | Prefix for all resource names, we recommend using your XMPro Company Name |
| `location`                     | Azure region for resource creation                                        |
| `ds_server_url`                | Datastream URL                                                            |
| `streamhost_collection_id`     | Default collection key for ds authentication.                             |
| `streamhost_collection_secret` | Default secret key for ds authentication.                                 |


**Note:** These secrets should be stored securely and never committed to version control.

### 3. Other properties that you want to configure for your deployment

## Core variables

Update the following properties used in `main.tf` to customize your deployment:

| Configuration Area | Variable                          | Required | Description                                                                                                                          | Default                               |
| ------------------ | --------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------- |
| **streamhost**     | `streamhost_name`                 | No       | Streamhost name                                                                                                                      | `aci-<prefix>-<location>-sh-01`       |
| **streamhost**     | `streamhost_container_image_base` | No       | The base docker container image (without tag) to be used by the stream host                                                          | `xmprononprod.azurecr.io/stream-host` |
| **streamhost**     | `streamhost_container_image_tags` | No       | List of docker container image tag(s) specifying the version and variant of the stream host. The first tag in the list will be used. | `["latest"]`                          |
| **streamhost**     | `streamhost_cpu`                  | No       | CPU count allocated to the container                                                                                                 | `1`                                   |
| **streamhost**     | `streamhost_memory`               | No       | Memory allocation (in GB) for the container                                                                                          | `4`                                   |

## Feature Flags

| Configuration Area | Variable                           | Required | Description                                                                                         | Default |
| ------------------ | ---------------------------------- | -------- | --------------------------------------------------------------------------------------------------- | ------- |
| **Resource Group** | `use_existing_rg`                  | No       | Set to true to use existing resource group                                                          | `false` |
| **Resource Group** | `resource_group_name`              | No       | Provide resource group name if variable `use_existing_rg` is set to true                            | `N/A`   |
| **Resource Group** | `resource_group_location`          | No       | Provide resource group location if variable `use_existing_rg` is set to true                        | `N/A`   |
| **Monitoring**     | `enable_monitoring`                | No       | Master switch to enable or disable all monitoring resources                                         | `true`  |
| **Monitoring**     | `enable_app_insights`              | No       | Enable Application Insights monitoring                                                              | `true`  |
| **Monitoring**     | `enable_log_analytics`             | No       | Enable Log Analytics workspace                                                                      | `true`  |
| **Monitoring**     | `use_existing_app_insights`        | No       | Set to true to use existing Application Insights                                                    | `false` |
| **Monitoring**     | `enable_app_insights_telemetry`    | No       | Enable Application Insights telemetry collection (requires app insights)                            | `true`  |
| **Monitoring**     | `appinsights_connectionstring`     | No       | Provide Application Insights connection string if `use_existing_app_insights` is true               | `N/A`   |
| **Monitoring**     | `use_existing_log_analytics`       | No       | Set to true to use existing Log Analytics                                                           | `false` |
| **Monitoring**     | `log_analytics_id`                 | No       | Provide Log Analytics workspace ID if `use_existing_log_analytics` is true                          | `N/A`   |
| **Monitoring**     | `log_analytics_primary_shared_key` | No       | Provide Log Analytics workspace primary shared key if `use_existing_log_analytics` is true          | `N/A`   |
| **Storage**        | `use_existing_storage_account`     | No       | Set to true to use existing storage account                                                         | `false` |
| **Storage**        | `volumes`                          | No       | Provide volume configuration with storage account details if `use_existing_storage_account` is true | `[]`    |

## Monitoring Configuration

The module provides comprehensive monitoring capabilities to ensure your StreamHost instances are properly observed and maintained. This includes both alerting for proactive notification and dashboards for visual monitoring.

### Alerting Configuration

This module provides comprehensive alerting capabilities for your StreamHost deployment, allowing you to monitor CPU usage and memory consumption. Alerts are enabled by default and can be configured to notify you via email, SMS, or webhooks.

### Alert Types

The module supports the following alert types:

| Alert Type        | Description                                        | Default Threshold |
| ----------------- | -------------------------------------------------- | ----------------- |
| CPU Usage         | Triggers when CPU utilization exceeds threshold    | 80%               |
| Memory Usage      | Triggers when memory utilization exceeds threshold | 80%               |
| Container Restart | Triggers when the container instance is restarted  | N/A               |
| Container Stop    | Triggers when the container instance is stopped    | N/A               |

#### Notification Channels

The module supports the following notification channels:

- **Email** - Send alert notifications to one or more email addresses
- **SMS** - Send text message alerts to one or more phone numbers
- **Webhook** - Send HTTP POST alerts to one or more webhook URLs

#### Alert Configuration Variables

| Configuration Area   | Variable                          | Required | Description                             | Default          |
| -------------------- | --------------------------------- | -------- | --------------------------------------- | ---------------- |
| **Master Switch**    | `enable_alerting`                 | No       | Enable/disable all alerts               | `true`           |
| **CPU Alerts**       | `enable_cpu_alerts`               | No       | Enable/disable CPU alerts               | `true`           |
| **CPU Alerts**       | `cpu_alert_threshold`             | No       | CPU usage percentage threshold          | `80`             |
| **CPU Alerts**       | `cpu_alert_severity`              | No       | Severity level (0-4)                    | `2`              |
| **Memory Alerts**    | `enable_memory_alerts`            | No       | Enable/disable memory alerts            | `true`           |
| **Memory Alerts**    | `memory_alert_threshold`          | No       | Memory usage percentage threshold       | `80`             |
| **Memory Alerts**    | `memory_alert_severity`           | No       | Severity level (0-4)                    | `2`              |
| **Container Alerts** | `enable_container_restart_alerts` | No       | Enable/disable container restart alerts | `true`           |
| **Container Alerts** | `enable_container_stop_alerts`    | No       | Enable/disable container stop alerts    | `true`           |
| **Email**            | `enable_email_alerts`             | No       | Enable email notifications              | `false`          |
| **Email**            | `alert_email_addresses`           | No       | List of recipient email addresses       | `[]`             |
| **SMS**              | `enable_sms_alerts`               | No       | Enable SMS notifications                | `false`          |
| **SMS**              | `alert_phone_numbers`             | No       | List of recipient phone numbers         | `[]`             |
| **SMS**              | `alert_phone_country_code`        | No       | Country code for SMS numbers            | `"1"` (US)       |
| **Webhook**          | `enable_webhook_alerts`           | No       | Enable webhook notifications            | `false`          |
| **Webhook**          | `alert_webhook_urls`              | No       | List of webhook URLs                    | `[]`             |
| **General**          | `alert_window_size`               | No       | Time window for metric alerts           | `"PT5M"` (5 min) |
| **General**          | `alert_evaluation_frequency`      | No       | Evaluation frequency                    | `"PT1M"` (1 min) |

#### Example Configuration

```hcl
module "streamhost" {
  source  = "XMPro/streamhost/xmpro"
  version = "0.0.5"
  
  # Required parameters
  prefix                          = "mycompany"
  location                        = "eastus"
  ds_server_url                   = "https://ds.example.com"
  streamhost_collection_id        = "your-collection-id"
  streamhost_collection_secret    = "your-collection-secret"
  
  # Alert configuration
  enable_alerting                 = true
  cpu_alert_threshold             = 85
  memory_alert_threshold          = 90
  
  # Email notifications
  enable_email_alerts             = true
  alert_email_addresses           = ["alerts@example.com", "admin@example.com"]
  
  # SMS notifications
  enable_sms_alerts               = true
  alert_phone_country_code        = "1"
  alert_phone_numbers             = ["5551234567", "5557654321"]
  
  # Webhook notifications
  enable_webhook_alerts           = true
  alert_webhook_urls              = ["https://hooks.example.com/alert"]
}
```

## Module Outputs

This module exposes the following outputs which can be referenced in your Terraform configuration:

| Output Name                        | Description                                         | Sensitive |
| ---------------------------------- | --------------------------------------------------- | --------- |
| `container_group_id`               | The ID of the container group                       | No        |
| `app_insights_instrumentation_key` | The instrumentation key for Application Insights    | Yes       |
| `app_insights_connection_string`   | The connection string for Application Insights      | Yes       |
| `log_analytics_workspace_id`       | The workspace ID for Log Analytics                  | No        |
| `resource_group_id`                | The ID of the resource group (if created by module) | No        |
| `resource_group_name`              | The name of the resource group used by this module  | No        |
| `streamhost_name`                  | The name of the StreamHost instance                 | No        |

> Some outputs contain sensitive information and are marked as sensitive. These values will be hidden in Terraform plan and apply output, but they are still stored in the state file. Handle the state file securely and consider using remote state with encryption. 

<br>

> **Important Configuration Notes:**
>
> When using existing resources:
>
> **Storage Account Share:**
> - If `use_existing_storage_account = true`, you must provide:
>   - Share name 
>   - Storage account name
>   - Storage account access key
>
> **Log Analytics:**
> - If `use_existing_log_analytics = true`, you must provide:
>   - Log analytics ID
>   - Log analytics primary shared key
>
> **Resource Group:**
> - If `use_existing_rg = true`, you must provide:
>   - Resource group name
>   - Resource group location
>
> **Monitoring Configuration:**
> - By default, all monitoring resources (Application Insights and Log Analytics) are enabled
> - Set `enable_monitoring = false` to completely disable all monitoring resources
> - Use `enable_app_insights = false` or `enable_log_analytics = false` to disable specific monitoring components
> - When both `enable_monitoring = true` and `use_existing_*` flags are set, the module will use existing resources instead of creating new ones
>
> **Resource Tagging:**
> - All resources created by this module will inherit the tags specified in the `tags` variable
> - If no tags are provided, resources will be created without any tags
> - To properly tag resources, provide a map of key-value pairs through the `tags` variable
>
> These details are required for the module to properly connect to your existing Azure resources.

### 4. Example format

Basic Configuration settings
```
    module "streamhost" {
        source                          = "XMPro/streamhost/xmpro"
        
        prefix                          = "<prefix>"
        location                        = "<location>"
        ds_server_url                   = "<datastream_stream_url>"
        streamhost_name                 = "<streamhost_name>"
        streamhost_collection_id        = "<datastream_collection_id>"
        streamhost_collection_secret    = "<datastream_collection_secret>"
        
        tags = {
            Environment = "Production"
            Department  = "IT"
            Owner       = "DevOps"
        }
    }
```


Advanced Configuration settings
```
    module "streamhost" {

                source = "XMPro/streamhost/xmpro"

        streamhost_name                  = "<streamhost_name>"
        streamhost_cpu                   = "<stremhost_cpu>"
        streamhost_memory                = "<streamhost_memory>"
        streamhost_container_image_base  = "<container_image>"
        streamhost_container_image_tags  = ["<container_image_tag>", "<another_container_image_tag>"]
     
        ds_server_url                    = "<datastream_stream_url>"
        streamhost_collection_id         = "<datastream_collection_id>"
        streamhost_collection_secret     = "<datastream_collection_secret>"

        enable_monitoring                = true
        enable_app_insights              = true
        enable_log_analytics             = true

        use_existing_app_insights         = true
        appinsights_connectionstring      = <application_insight_connection_string>

        use_existing_rg                   = true 
        resource_group_name              = "<resource_group_name>"
        resource_group_location          = "<resource_group_location>"

        environment_variables            = {
            "key" : "value"
        }

        use_existing_storage_account     = true

        volumes                          =  [{
            name                         = "<volume-name>"
            mount_path                   = "<volume-path>"
            read_only                    = false
            share_name                   = "<volume_name>"
            storage_account_name         = "<storage_name>"
            storage_account_key          = "<primary_access_key>"
        }]

        use_existing_log_analytics        = true 

        log_analytics_id                  = <log_analytics_id>
        log_analytics_primary_shared_key  = <log_analytics_primary_shared_key>

        tags = {
            Environment     = "Production"
            Department      = "Operations"
            CostCenter      = "CC-123456"
            BusinessUnit    = "Analytics"
            Owner           = "john.doe@example.com"
            ProjectName     = "DataStreaming"
            ApplicationName = "XMPro StreamHost"
            Managed_By      = "Terraform"
        }
    }
```