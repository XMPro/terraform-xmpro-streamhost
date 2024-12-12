locals {
  streamhost = {
    default = {
      streamhost_name               = "sh-01-tfaci-default-${var.environment}-${var.location}"
      ds_server_url                 = var.ds_server_url
      streamhost_collection_id      = var.streamhost_default_collection_id
      streamhost_collection_secret  = var.streamhost_default_collection_secret
      streamhost_container_image    = var.streamhost_default_container_image
      streamhost_cpu                = var.sh_default_cpu
      streamhost_memory             = var.sh_default_memory
      env_variables                 = {}
      volumes                       = []
    },
    ai = {
      streamhost_name               = "sh-02-tfaci-ai-${var.environment}-${var.location}"
      ds_server_url                 = var.ds_server_url
      streamhost_collection_id      = var.streamhost_ai_collection_id
      streamhost_collection_secret  = var.streamhost_ai_collection_secret
      streamhost_container_image    = var.streamhost_ai_container_image
      streamhost_cpu                = var.sh_ai_cpu
      streamhost_memory             = var.sh_ai_memory
      env_variables = {
        "AZURE_OPENAI_CHAT_DEPLOYMENT_NAME"       = "${var.docker_azure_openaichatdeploymentname}"
        "AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT_NAME" = "${var.docker_azure_openaiembeddingsdeploymentname}"
        "OPENAI_API_VERSION"                      = "${var.docker_openaiversion}"
        "SCRIPT_PATH"                             = "${var.docker_migration_script_path}"
      }
      volumes = [{
        name                 = "rag-data"
        mount_path           = "/scripts"
        read_only            = false
        share_name           = azurerm_storage_share.sh_data.name
        storage_account_name = azurerm_storage_account.storage_account.name
        storage_account_key  = azurerm_storage_account.storage_account.primary_access_key
      }]
    }
  }
}

module "xmpro" {
  source = "../../"

  for_each = local.streamhost

  prefix      = var.prefix
  environment = var.environment
  location    = var.location

  ds_server_url                     = each.value.ds_server_url
  streamhost_collection_id          = each.value.streamhost_collection_id
  streamhost_collection_secret      = each.value.streamhost_collection_secret

  streamhost_name                   = each.value.streamhost_name
  streamhost_cpu                    = each.value.streamhost_cpu
  streamhost_memory                 = each.value.streamhost_memory
  streamhost_container_image        = each.value.streamhost_container_image

  use_existing_app_insights         = true
  appinsights_connectionstring      = azurerm_application_insights.sh_appinsights_adex.connection_string

  use_existing_rg                   = true 
  resource_group_name               = azurerm_resource_group.xmpro_sh_rg_adex.name
  resource_group_location           = azurerm_resource_group.xmpro_sh_rg_adex.location

  use_existing_log_analytics        = true 
  log_analytics_id                  = azurerm_log_analytics_workspace.sh_log_analytics_adex.workspace_id
  log_analytics_primary_shared_key  = azurerm_log_analytics_workspace.sh_log_analytics_adex.primary_shared_key

  environment_variables             = each.value.env_variables

  use_existing_storage_account      = true
  volumes                           = each.value.volumes
}