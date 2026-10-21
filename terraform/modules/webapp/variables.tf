variable "name_prefix" {
  type = string
}
variable "location" {
  type = string
}
variable "environment" {
  type = string
}
variable "app_sku" {
  type = string
}
variable "sql_sku" {
  type = string
}
variable "sql_admin_login" {
  type = string
}
variable "sql_admin_password" {
  type      = string
  sensitive = true
}
