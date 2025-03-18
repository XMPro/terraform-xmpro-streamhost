resource "random_uuid" "sh_id" {
}

resource "azurerm_container_group" "streamhost" {
  name                = "cg-${local.sh_name}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  ip_address_type     = "Public"
  os_type             = "Linux"

  image_registry_credential {
    server   = var.acr_url
    username = var.acr_username
    password = var.acr_password
  }
  container {
    name   = "aci-${local.sh_name}"
    image  = local.streamhost_container_image_with_version
    cpu    = var.streamhost_cpu
    memory = var.streamhost_memory

    environment_variables = merge(
      var.environment_variables,
      {
        "xm__xmpro__Gateway__Id"           = random_uuid.sh_id.result
        "xm__xmpro__Gateway__Name"         = "aci-${local.sh_name}"
        "xm__xmpro__Gateway__ServerUrl"    = var.ds_server_url
        "xm__xmpro__Gateway__CollectionId" = var.streamhost_collection_id
      }, 
      (local.effective_enable_app_insights_telemetry && local.app_insights_conn_string != null) ? {
        "xm__xmpro__gateway__featureflags__enableapplicationinsightstelemetry" = true
      } : {}
    )

    secure_environment_variables = merge(
      {
        "xm__xmpro__Gateway__Secret" = var.streamhost_collection_secret
      }, 
      (local.app_insights_conn_string != null) ? {
        "xm__ApplicationInsights__ConnectionString" = local.app_insights_conn_string
      } : {}
    )

    dynamic "volume" {
      for_each = var.use_existing_storage_account ? var.volumes : []
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

  dynamic "diagnostics" {
    for_each = (local.log_analytics_id != null && local.log_analytics_primary_shared_key != null) ? [1] : []
    content {
      log_analytics {
        workspace_id  = local.log_analytics_id
        workspace_key = local.log_analytics_primary_shared_key
        log_type      = "ContainerInsights"
      }
    }
  }

  tags = var.tags
}