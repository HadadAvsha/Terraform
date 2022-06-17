
output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.postgres_flex_server.name
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.postgres.name
}