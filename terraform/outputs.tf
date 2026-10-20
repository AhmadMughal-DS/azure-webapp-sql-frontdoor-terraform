output "frontdoor_endpoint" {
  description = "Public Front Door endpoint hostname"
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "web_app_default_hostname" {
  description = "App Service default hostname (origin)"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "sql_server_fqdn" {
  description = "Azure SQL server FQDN"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}
