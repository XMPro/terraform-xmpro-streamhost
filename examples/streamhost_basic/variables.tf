
#This where added for azure_containerinstances.tf
variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "shcontainers"
}

variable "environment" {
  description = "The environment name used for resource identification (e.g., dev, staging, prod)"
  default     = "demo"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "southeastasia"
}

variable "ds_server_url" {
  description = "URL of the Data Stream server"
  default     = "<https://ds.exmaple.com>"
  sensitive   = true
}

variable "streamhost_collection_id" {
  description = "default streamHost collection identifier used for authentication"
  default     = "<streamhost_collection_id>"
  sensitive   = true
}

variable "streamhost_collection_secret" {
  description = "default streamHost collection secret used for authentication"
  default     = "<streamhost_collection_secret>"
  sensitive   = true
}