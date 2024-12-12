# XMPro - Streamhost Terraform Module Advance Example

## Overview
This Terraform module deploys and configures XMPro Streamhost resources on Azure. It provides a flexible configuration framework for resource deployment, environment management, and infrastructure scaling.

> 💡 **Tip**: Press `Ctrl + Shift + V` in VS Code to preview this Markdown file.

## Prerequisite

### Required Tools

| Tool                      | Version | Purpose                 | Installation Link                                                                                         |
|------                     |---------|---------                |-------------------                                                                                        |
| Terraform CLI             | >= 1.0  | Infrastructure as Code  | [Install Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)          |
| Azure CLI                 | Latest  | Azure Management        | [Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)     |
| Azure Portal Access       | N/A     | Cloud Management        | [Portal](https://portal.azure.com/)                                                                       |
| PowerShell/Ubuntu Bash    | Latest  | Command Line Interface  | [Ubuntu](https://www.microsoft.com/store/productId/9PN20MSR04DW)                                          |    
| XMPro Git Repository      | Latest  | Source Code             | [Repository](https://xmpro.visualstudio.com/DefaultCollection/XMPro%20Development/_git/xmpro-development) |
| VS Code (Optional)        | Latest  | IDE                     | [Download](https://code.visualstudio.com/)                                                                |

> **Note**: Ensure you have an active Azure subscription.

## Quick Start Guide

### 1. Security Configuration

Navigate to `terraform/modules/terraform-xmpro-streamhost/examples/streamhost` and configure the following sensitive parameters in `variables.tf`:

The following variables are the ones you need to configure so that the newly created streamhost will reflect in your data stream application.

```hcl
  variable "ds_server_url" {
    description = "Datastream URL"
    type        = string
    sensitive   = true
  }

  variable "streamhost_default_collection_id" {
    description = "Default collection key for DS authentication"
    type        = string
    sensitive   = true
  }

  variable "streamhost_default_collection_secret" {
    description = "Default secret key for DS authentication"
    type        = string
    sensitive   = true
  }

  variable "streamhost_ai_collection_id" {
    description = "AI collection key for DS authentication"
    type        = string
    sensitive   = true
  }

  variable "streamhost_ai_collection_secret" {
    description = "AI secret key for DS authentication"
    type        = string
    sensitive   = true
  }
```

> 🔒 **Security Note**: Never commit sensitive values to version control. Use environment variables or secure vaults.

### 2. Resource Configuration

#### Core Variables
The following variables can be configured to customize the names and other resources when your app is deployed. 


| Configuration Area  | Variable                             | Required   | Description                    |     Default                                             |
|----------           |----------                            |----------  |-------------                   |---------                                                |
|  **Basic Config**   | `prefix`                             | Yes        | Resource naming prefix         | `xmdemo`                                                | 
|  **Basic Config**   | `environment`                        | Yes        | Deployment environment         | `demo`                                                  | 
|  **Basic Config**   | `location`                           | Yes        | Azure region                   | `australiaeast`                                         |    
|  **Streamhost**     | `streamhost_name`                    | No         | Instance name                  | `sh-01-tfaci-default-<prefix>-<environment>-<location>` |
|  **Streamhost**     | `streamhost_container_image`         | No         | Docker image version           | `latest`                                                |
|  **Performance**    | `streamhost_cpu`                     | No         | CPU allocation                 | `1`                                                     |
|  **Performance**    | `streamhost_memory`                  | No         | Memory allocation (GB)         | `4`                                                     |
|  **Config**         | `environment_variables`              | No         | Variables declared by the user | `[]`                                                    |

### Feature Flags
The following variables can be configured to enable or disable specific features of the Streamhost instance.

| Configuration Area  | Variable                             | Required   |                       Description                                                                   |   Default  |
|----------           |----------                            |----------  |-------------                                                                                        |---------   |
|  **Resource Group** | `use_existing_rg`                    | No         | Set to true to use existing rg.                                                                     | `false`    |
|  **Resource Group** | `resource_group_name`                | No         | Provide rg name if variable `use_existing_rg` is set to true.                                       | `N/A`      | 
|  **Resource Group** | `resource_group_location`            | No         | Provide rg location if variable `use_existing_rg` is set to true.                                   | `N/A`      |      
|  **Monitoring**     | `use_existing_app_insights`          | No         | Set to true to use existing app insights.                                                           | `false`    |
|  **Monitoring**     | `appinsights_connectionstring`       | No         | Provide app-insights connection string if `use_existing_app_insights` is true.                      | `N/A`      |
|  **Monitoring**     | `use_existing_log_analytics`         | No         | Set to true to use existing log analytics.                                                          | `false`    |  
|  **Monitoring**     | `log_analytics_id`                   | No         | Provide log Analytics workspace id if `use_existing_log_analytics` is true.                         | `N/A`      |
|  **Monitoring**     | `log_analytics_primary_shared_key`   | No         | Provide log analytics workspace primary shared key if `use_existing_log_analytics` is true.         | `N/A`      |
|  **Storage**        | `use_existing_storage_account`       | No         | Set to true to use existing storage account.                                                        | `false`    |
|  **Storage**        | `volumes`                            | No         | Provide volume configuration with storage account details if `use_existing_storage_account` is true.| `[]`       |


## Authentication

Before running the Terraform commands, ensure that you are authorized in Azure by following these steps:
1. Open a command prompt (CMD) and run `az login`.
2. You will be prompted to navigate to a URL.
3. Access the URL in your browser, and you will be asked to enter the code displayed in the CMD.
4. After entering the code, log in using your email account.
5. Once logged in, you will receive a confirmation that you are signed in, and you can close the browser.
6. Select the subscription you will be using. (e.g., Visual Studio subscription).

## Deployment

### Standard Deployment

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

### Automated Deployment

```bash
#!/bin/bash
terraform init && \
terraform apply -auto-approve
```

## Monitoring

After deployment, monitor your resources through:

1. **Azure Portal**: Navigate to your resource group
2. **Application Insights**: Check performance metrics
3. **Log Analytics**: Query logs using Kusto Query Language (KQL)



<br> ⚠️ **Warning**: Always run `terraform destroy` when you need to remove deployed resources to avoid unnecessary charges.

<br>
**Note:** Keep this documentation updated as the module evolves. Last updated: 2024
