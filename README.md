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

| Property                       | Description                                                          |
|------------------------------  |-----------------------------------------------                       |
| `prefix`                       | Prefix for all resource names                                        |
| `environment`                  | Specifies the target environment (e.g., dev, prod) for the resources |
| `location`                     | Azure region for resource creation                                   |
| `ds_server_url`                | Datastream URL                                                       |
| `streamhost_collection_id`     | Default collection key for ds authentication.                        |
| `streamhost_collection_secret` | Default secret key for ds authentication.                            | 


**Note:** These secrets should be stored securely and never committed to version control.

### 3. Other properties that you want to configure for your deployment

## Core variables

Update the following properties used in `main.tf` to customize your deployment:

| Configuration Area | Variable                              | Required   | Description                                           |  Default                                                |
|----------          |------------------------------         | ----       | ------------------                                    |------------------                                       |
|  **streamhost**    | `streamhost_name`                     | No         | Streamhost name                                       | `sh-01-tfaci-default-<prefix>-<environment>-<location>` |
|  **streamhost**    | `streamhost_container_image`          | No         | Version of the Docker image to deploy                 | `latest`                                                |
|  **streamhost**    | `streamhost_cpu`                      | No         | CPU count allocated to the container                  | `1`                                                     |
|  **streamhost**    | `streamhost_memory`                   | No         | Memory allocation (in GB) for the container           | `4`                                                     |  
|  **configuration** | `environment_variables`               | No         | Specify the environment keys needed in the container  | `[]`                                                    |

## Feature Flags

| Configuration Area | Variable                             | Required   | Description                                                                 | Default |
|--------------------|--------------------------------------|------------|-----------------------------------------------------------------------------|---------|
| **Resource Group** | `use_existing_rg`                    | No         | Set to true to use existing resource group                                  | `false` |
| **Resource Group** | `resource_group_name`                | No         | Provide resource group name if variable `use_existing_rg` is set to true    | `N/A`   |
| **Resource Group** | `resource_group_location`            | No         | Provide resource group location if variable `use_existing_rg` is set to true| `N/A`   |
| **Monitoring**     | `use_existing_app_insights`          | No         | Set to true to use existing Application Insights                            | `false` |
| **Monitoring**     | `appinsights_connectionstring`       | No         | Provide Application Insights connection string if `use_existing_app_insights` is true | `N/A` |
| **Monitoring**     | `use_existing_log_analytics`         | No         | Set to true to use existing Log Analytics                                   | `false` |
| **Monitoring**     | `log_analytics_id`                   | No         | Provide Log Analytics workspace ID if `use_existing_log_analytics` is true  | `N/A`   |
| **Monitoring**     | `log_analytics_primary_shared_key`   | No         | Provide Log Analytics workspace primary shared key if `use_existing_log_analytics` is true | `N/A` |
| **Storage**        | `use_existing_storage_account`       | No         | Set to true to use existing storage account                                 | `false` |
| **Storage**        | `volumes`                            | No         | Provide volume configuration with storage account details if `use_existing_storage_account` is true | `[]` |

<br>

> **Important Configuration Notes:**
>
> When using existing resources:
>
> **Storage Account Share:**
> - If `use_existing_storage_account_share = true`, you must provide:
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
> These details are required for the module to properly connect to your existing Azure resources.

### 4. Example format

Basic Configuration settings
```
    module "streamhost" {
        source                          = "XMPro/streamhost/xmpro"
        
        prefix                          = "<prefix>"
        environment                     = "<environment>"
        location                        = "<location>"
        ds_server_url                   = "<datastream_stream_url>"
        streamhost_name                 = "<streamhost_name>"
        streamhost_collection_id        = "<datastream_collection_id>"
        streamhost_collection_secret    = "<datastream_collection_secret>"
    }
```


Advanced Configuration settings
```
    module "streamhost" {

        source = "XMPro/streamhost/xmpro"

        streamhost_name                  = "<streamhost_name>"
        streamhost_cpu                   = "<stremhost_cpu>"
        streamhost_memory                = "<streamhost_memory>"
        streamhost_container_image       = "<container_image>"
     
        ds_server_url                    = "<datastream_stream_url>"
        streamhost_collection_id         = "<datastream_collection_id>"
        streamhost_collection_secret     = "<datastream_collection_secret>"

        use_existing_app_insights         = true
        appinsights_connectionstring      = <application_insight_connection_string>

        use_existing_rg                   = true 
        resource_group_name              = "<resource_group_name>"
        resource_group_location          = "<resource_group_location>"

        environment_variables            = {
            "key" : "value"
        }

        use_existing_storage_account     = true

        volumes                          =  volumes = [{
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


    }
```

## Authentication Setup

Before running the Terraform commands, ensure that you are authorized in Azure by following these steps:
1. Open a command prompt (CMD) and run `az login`.
2. You will be prompted to navigate to a URL.
3. Access the URL in your browser, and you will be asked to enter the code displayed in the CMD.
4. After entering the code, log in using your email account.
5. Once logged in, you will receive a confirmation that you are signed in, and you can close the browser.
6. Select the subscription you will be using. (e.g., Visual Studio subscription).

## Running the Terraform Configuration

Once variables are set and authentication is complete, run the following Terraform commands in order:

| Command             | Description                                                                                             |
|---------------------|-----------------------------------------------------------------------------                            |
| `terraform init`    | Initializes the Terraform configuration by downloading necessary plugins and setting up the backend.    |
| `terraform apply`   | Applies the changes required to reach the desired state of the configuration.                           |
| `terraform destroy` | Destroys the Terraform-managed infrastructure, reverting all changes made by `terraform apply`.         |

You can visit the [Azure Portal](https://portal.azure.com/#home) to verify the resources that have been created.



