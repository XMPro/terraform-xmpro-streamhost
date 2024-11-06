# XMPro - Streamhost Terraform Module

## Overview
This Terraform module provides a configuration for deploying resources on Azure using Terraform CLI Commands. It includes customizable variables for resource naming, environment specifications, and resource allocations.

## Prerequisites:
* Terraform CLI
* shell to run cli - (powershell or bash/etc)
* IDE: vscode (optional)

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

- `ds_server_url`           : Datastream URL
- `streamhost_collection_id`: Default collection key for ds authentication.
- `streamhost_secret`       : Default secret key for ds authentication.
- `resource_group_name`     : Name of the resource group.
- `resource_group_location` : Location of the resource group.

**Note:** These secrets should be stored securely and never committed to version control.

### 3. Other properties that you want to configure for your deployment

Update the following properties used in `main.tf` to customize your deployment:

| Property                             | Description                                                                                  |
|------------------------------        |-------------------------------------------------------------------                           |
| `prefix`                             | Prefix for all resource names                                                                |
| `environment`                        | Specifies the target environment (e.g., dev, prod) for the resources                         |
| `location`                           | Azure region for resource creation                                                           |
| `resource_group_name`                | [required] Azure region for resource creation                                                |
| `resource_group_location`            | [required] Azure region for resource creation                                                |
| `streamhost_name`                    | Streamhost name                                                                              |
| `ds_server_url`                      | [required] URL of the Data Stream (DS) where your collection is located                      |
| `streamhost_collection_id`           | [required] Collection ID from your Data Source (DS) collection                               |
| `streamhost_secret`                  | [required] Secret key from your Data Source (DS) collection                                  |
| `streamhost_container_image`         | Version of the Docker image to deploy                                                        |
| `appinsights_connectionstring`       | Connection string for Azure Application Insights                                             |
| `log_analytics_id`                   | Connection string for Azure Application Insights                                             |
| `log_analytics_primary_shared_key`   | Connection string for Azure Application Insights                                             |
| `streamhost_cpu`                     | CPU count allocated to the container                                                         |
| `streamhost_memory`                  | Memory allocation (in GB) for the container                                                  |
| `environment_variables`              | Specify the environment keys needed in the container                                         |
| `volumes`                            | Specify the volume attached to the container streamhost                                      |
| `use_existing_storage_account_share` | Default is `true`. Set to `true` to create a new share, or `false` to use an existing share. |

If you set `use_existing_storage_account_share` to `true`, you must provide the details of the existing storage account, including the storage account name, share name, and access key.

### 4. Example format

```
    module "streamhost" {

        source = "XMPro/streamhost/xmpro"

        streamhost_name                  = "<streamhost_name>"
        streamhost_cpu                   = "<stremhost_cpu>"
        streamhost_memory                = "<streamhost_memory>"
        streamhost_container_image       = "<container_image>"
     
        streamhost_collection_id         = "<datastream_collection_id>"
        streamhost_secret                = "<datastream_collection_secret>"
        appinsights_connectionstring     = "<appinsights_connectionstring>"
        ds_server_url                    = "<datastream_stream_url>"

        prefix                           = "<prefix>"
        environment                      = "<environment>"
        location                         = "<location>"
        log_analytics_id                 = "<workspace_id>"
        log_analytics_primary_shared_key = "<primary_shared_key>"
        resource_group_name              = "<resource_group_name>"
        resource_group_location          = "<resource_group_location>"

        environment_variables            = {
            "key" : "value"
        }

        volumes                          =  volumes = [{
            name                 = "<volume-name>"
            mount_path           = "<volume-path>"
            read_only            = false
            share_name           = "<volume_name>"
            storage_account_name = "<storage_name>"
            storage_account_key  = "<primary_access_key>"
        }]

        use_existing_storage_account_share = true
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



