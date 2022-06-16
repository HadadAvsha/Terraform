resource "azurerm_postgresql_flexible_server_database" "postgres" {
  name      = "avshsapostgres"
  server_id = azurerm_postgresql_flexible_server.postgres_flex_server.id
  collation = "en_US.UTF8"
  charset   = "UTF8"
}