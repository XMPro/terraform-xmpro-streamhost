
#This where added for azure_containerinstances.tf
variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "shadex"
}

variable "environment" {
  description = "The environment name used for resource identification (e.g., dev, staging, prod)"
  default     = "demo"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "southeastasia"
}

variable "streamhost_default_collection_id" {
  description = "default streamHost collection identifier used for authentication"
  default     = "default_ds_collection_id"
  sensitive   = true
}

variable "streamhost_default_collection_secret" {
  description = "default streamHost collection secret used for authentication"
  default     = "default_ds_secret"
  sensitive   = true
}

variable "streamhost_ai_collection_id" {
  description = "ai streamHost collection identifier used for authentication"
  default     = "ai_ds_collection_id"
  sensitive   = true
}

variable "streamhost_ai_collection_secret" {
  description = "ai streamHost collection secret used for authentication"
  default     = "ai_ds_secret"
  sensitive   = true
}

variable "ds_server_url" {
  description = "value"
  default     = "https://ds123.devupw2svz.xmpro.com/"
  sensitive   = true
}

variable "streamhost_default_container_image" {
  description = "container imaged for the default streamhost"
  default     = "xmprocontrib.azurecr.io/sh-debian-ai-assistant:latest"
}

variable "streamhost_ai_container_image" {
  description = "container imaged for the default streamhost"
  default     = "xmprocontrib.azurecr.io/sh-debian-ai-assistant:latest"
}

variable "sh_default_cpu" {
  description = "resource cpu use for the container streamhost"
  default     = 1
}

variable "sh_default_memory" {
  description = "resource memory use for the container streamhost"
  default     = 4
}

variable "sh_ai_cpu" {
  description = "resource cpu use for the container streamhost"
  default     = 1
}

variable "sh_ai_memory" {
  description = "resource memory use for the container streamhost"
  default     = 4
}

variable "docker_migration_script_path" {
  description = "value"
  default     = "/scripts"
}

variable "docker_azure_openaichatdeploymentname" {
  description = "Azure chat deployment name to be used by the stream host"
  default     = "gpt4o"
}

variable "docker_azure_openaiembeddingsdeploymentname" {
  description = "Azure embeddings deployment name by the stream host"
  default     = "text-embedding-ada-002"
}

variable "docker_openaiversion" {
  description = "Azure openai version by the stream host"
  default     = "2024-02-01"
}