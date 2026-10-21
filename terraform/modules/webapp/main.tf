resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-rg"
  location = var.location
}

############################
# App Service (Linux)
############################
resource "azurerm_service_plan" "this" {
  name                = "${var.name_prefix}-plan"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_sku
}

resource "azurerm_linux_web_app" "this" {
  name                = "${var.name_prefix}-app-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    SQL_SERVER   = azurerm_mssql_server.this.fully_qualified_domain_name
    SQL_DATABASE = azurerm_mssql_database.this.name
  }
}

############################
# Azure SQL
############################
resource "azurerm_mssql_server" "this" {
  name                         = "${var.name_prefix}-sql-${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "this" {
  name           = "appdb"
  server_id      = azurerm_mssql_server.this.id
  sku_name       = var.sql_sku
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

############################
# Front Door (Standard)
############################
resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "${var.name_prefix}-fd"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "${var.name_prefix}-ep"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = "${var.name_prefix}-og"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  name                           = "${var.name_prefix}-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.this.id
  enabled                        = true
  host_name                      = azurerm_linux_web_app.this.default_hostname
  origin_host_header             = azurerm_linux_web_app.this.default_hostname
  http_port                      = 80
  https_port                     = 443
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "this" {
  name                          = "${var.name_prefix}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.this.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  https_redirect_enabled        = true
  link_to_default_domain        = true
}
