variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "xmdemo"
}
variable "environment" {
  description = "The environment name used for resource naming and tagging"
  default     = "demo"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
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
  default     = "SH-01-TFACI-DEFAULT"
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

variable "streamhost_secret" {
  description = "The collection secret of the stream host"
  type        = string
  sensitive   = true
}

variable "appinsights_connectionstring" {
  description = "The connection string of the application insights"
  type        = string
  sensitive   = true
  default     = "InstrumentationKey=00000000-0000-0000-0000-000000000000;IngestionEndpoint=https://westeurope-1.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/"
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

variable "streamhost_container_image" {
  description = "The docker container image to be used by the stream host"
  default     = "xmprocontrib.azurecr.io/sh-debian-ai-assistant:latest"
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

variable "use_existing_storage_account_share" {
  description = "set to true to use an existing storage account share, false to create a new one"
  type        = bool
  default     = true
}