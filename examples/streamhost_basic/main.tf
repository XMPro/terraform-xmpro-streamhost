module "xmpro" {
  source = "../../"

  prefix      = var.prefix
  environment = var.environment
  location    = var.location

  ds_server_url                = var.ds_server_url
  streamhost_collection_id     = var.streamhost_collection_id
  streamhost_collection_secret = var.streamhost_collection_secret
}