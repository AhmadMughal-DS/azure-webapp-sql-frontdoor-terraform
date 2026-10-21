output "frontdoor_endpoint" {
  value = azurerm_cdn_frontdoor_endpoint.this.host_name
}
output "web_app_default_hostname" {
  value = azurerm_linux_web_app.this.default_hostname
}
output "sql_server_fqdn" {
  value = azurerm_mssql_server.this.fully_qualified_domain_name
}
