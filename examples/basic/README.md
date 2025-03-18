# XMPro - Streamhost Terraform Module Basic Example

## Overview
This example demonstrates how to deploy an XMPro Streamhost on Azure using Terraform. The Streamhost is a container instance that connects to your XMPro Datastream application, enabling real-time data processing and AI capabilities.

> 💡 **Tip**: Press `Ctrl + Shift + V` in VS Code to preview this Markdown file.

## Prerequisites

### Required Tools

| Tool              | Version | Purpose                | Installation Link                                                                                    |
|-------------------|---------|------------------------|-----------------------------------------------------------------------------------------------------|
| Terraform CLI     | >= 1.0  | Infrastructure as Code | [Install Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)     |
| Azure CLI         | Latest  | Azure Authentication   | [Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)                       |
| Azure Subscription| N/A     | Resource Deployment    | [Portal](https://portal.azure.com/)                                                                  |

## Quick Start Guide

### 1. Authentication Setup

Before running any Terraform commands, authenticate with Azure:

```bash
# Log in to Azure
az login

# If you have multiple subscriptions, select the one you want to use
az account set --subscription "your-subscription-id"
```

### 2. Configure Your Deployment

Edit the `main.tf` file with your specific settings:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "xmpro" {
  source = "XMPro/streamhost/xmpro"
  
  # Required parameters
  prefix                       = "mycompany"              # Your company name or project identifier
  location                     = "centralus"              # Azure region for deployment
  
  # XMPro Datastream connection (get these from your XMPro admin)
  ds_server_url                = "https://ds.example.com" # Your Datastream URL
  streamhost_collection_id     = "your-collection-id"     # Collection ID for authentication
  streamhost_collection_secret = "your-collection-secret" # Collection secret for authentication
}
```

> 🔒 **Security Note**: Never commit sensitive values to version control. Consider using environment variables, Azure Key Vault, or Terraform variables files (*.tfvars) that are excluded from your repository.

### 3. Deploy the Streamhost

Run the following commands to deploy your Streamhost:

```bash
# Initialize Terraform working directory
terraform init

# Preview changes before applying
terraform plan

# Deploy the resources
terraform apply
```

After confirming the deployment plan, Terraform will create your Streamhost resources in Azure.

### 4. Verify Deployment

Once deployment is complete, you can verify your Streamhost is running:

1. Check the Azure Portal for the new container instance
2. Verify in your XMPro Datastream application that the Streamhost is connected

## Customization Options

The basic example covers minimal settings, but you can customize your deployment with additional parameters:

```hcl
module "xmpro" {
  source = "XMPro/streamhost/xmpro"
  
  # Required parameters
  prefix                       = "mycompany"
  location                     = "centralus"
  ds_server_url                = "https://ds.example.com"
  streamhost_collection_id     = "your-collection-id"
  streamhost_collection_secret = "your-collection-secret"
  
  # Optional customizations
  streamhost_name              = "custom-streamhost-name"  # Custom name (default: based on prefix)
  streamhost_cpu               = 2                         # CPU cores (default: 1)
  streamhost_memory            = 8                         # Memory in GB (default: 4)
  
  # Add custom environment variables if needed
  environment_variables = {
    "CUSTOM_SETTING" = "value"
  }
  
  # Add resource tags
  tags = {
    Environment = "Development"
    Department  = "IT"
    Project     = "XMPro Integration"
  }
}
```

## Cleanup

When you're done with the resources, remove them to avoid unnecessary charges:

```bash
terraform destroy
```

## Advanced Configuration

For advanced scenarios such as using existing resource groups, configuring monitoring, or setting up alerting, please refer to the main module documentation.

## Troubleshooting

If you encounter issues:

1. Verify your Azure authentication is current
2. Check that your XMPro credentials (collection ID and secret) are correct
3. Review the Terraform apply logs for specific error messages

For additional help, contact your XMPro support representative.

---

Last updated: March 13, 2025