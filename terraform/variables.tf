variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Name prefix applied to all resources"
  type        = string
  default     = "ahmad-webapp"
}

variable "sql_admin_login" {
  description = "Azure SQL administrator login"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Azure SQL administrator password (pass via TF_VAR_sql_admin_password)"
  type        = string
  sensitive   = true
}
