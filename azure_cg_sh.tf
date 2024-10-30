resource "random_uuid" "sh_id" {
  # for_each = { for key, value in var.container_streamhost_data : key => value }
}

resource "azurerm_container_group" "streamhost" {
  # for_each = { for key, value in var.container_streamhost_data : key => value }
  name                = "cg-${var.streamhost_name}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  # dns_name_label      = "cg-${var.prefix}-${each.value.name}-${var.environment}-${var.location}"
  os_type             = "Linux"

  container {
    name = "sh"
    image  = var.streamhost_container_image
    cpu    = var.streamhost_cpu
    memory = var.streamhost_memory

    environment_variables = {
      "xm__xmpro__Gateway__Id"                    = random_uuid.sh_id.result
      #"xm__xmpro__Gateway__Name"                  = format("SH-%02d-%s-ACI-%s", index(keys(var.container_streamhost_data), each.key) + 1, each.value.name, var.environment)
      "xm__xmpro__Gateway__Name"                  = var.streamhost_name
      "xm__xmpro__Gateway__ServerUrl"             = var.ds_server_url
      "xm__xmpro__Gateway__CollectionId"          = var.streamhost_collection_id
      "xm__xmpro__Gateway__Secret"                = var.streamhost_secret
      "xm__ApplicationInsights__ConnectionString" = var.appinsights_connectionstring
      # "AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"       = "${var.docker_azure_openaichatdeploymentname}"
      # "AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT_NAME" = "${var.docker_azure_openaiembeddingsdeploymentname}"
      # "OPENAI_API_VERSION"                      = "${var.docker_openaiversion}"
      # "SCRIPT_PATH" = "${var.docker_migration_script_path}"
    }

    # volume {
    #   name       = "rag-data"
    #   mount_path = "/scripts"
    #   read_only  = false
    #   share_name = azurerm_storage_share.sh_data.name

    #   storage_account_name = var.storage_account_name
    #   storage_account_key  = var.storage_account_primary_access_key

    # }

    ports {
      port     = 5000
      protocol = "TCP"

    }
  }

  diagnostics {
    log_analytics {
      workspace_id  = var.log_analytics_id
      workspace_key = var.log_analytics_primary_shared_key
      log_type      = "ContainerInsights"
    }
  }

  tags = {
    product    = "XMPRO-${var.streamhost_name}"
    createdby  = "XMPRO terraform streamhost module"
    createdfor = "${var.prefix}-${var.environment}"
  }
}