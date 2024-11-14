
resource "random_uuid" "sh_id" {
}

resource "azurerm_container_group" "streamhost" {
  name                = "cg-${var.streamhost_name}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  os_type             = "Linux"

  image_registry_credential {
    server   = var.acr_url
    username = var.acr_username
    password = var.acr_password
  }
  container {
    name   = "sh"
    image  = var.streamhost_container_image
    cpu    = var.streamhost_cpu
    memory = var.streamhost_memory



    environment_variables = merge(
      var.environment_variables,
      {
        "xm__xmpro__Gateway__Id"                    = random_uuid.sh_id.result
        "xm__xmpro__Gateway__Name"                  = var.streamhost_name
        "xm__xmpro__Gateway__ServerUrl"             = var.ds_server_url
        "xm__xmpro__Gateway__CollectionId"          = var.streamhost_collection_id
        "xm__xmpro__Gateway__Secret"                = var.streamhost_secret
        "xm__ApplicationInsights__ConnectionString" = var.appinsights_connectionstring
      }
    )

    dynamic "volume" {
      for_each = var.use_existing_storage_account_share ? var.volumes : []
      content {
        name                 = volume.value.name
        mount_path           = volume.value.mount_path
        read_only            = try(volume.value.read_only, false)
        share_name           = volume.value.share_name
        storage_account_name = volume.value.storage_account_name
        storage_account_key  = volume.value.storage_account_key
      }
    }

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
    createdby  = "admin-${var.streamhost_name}"
    createdfor = "${var.prefix}-${var.environment}-docker"
  }
}