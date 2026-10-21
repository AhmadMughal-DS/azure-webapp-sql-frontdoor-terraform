locals {
  name_prefix = var.project_name
}

module "webapp" {
  source             = "./modules/webapp"
  name_prefix        = local.name_prefix
  location           = var.location
  environment        = var.environment
  app_sku            = var.app_sku
  sql_sku            = var.sql_sku
  sql_admin_login    = var.sql_admin_login
  sql_admin_password = var.sql_admin_password
}
