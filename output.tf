output "db_passsword" {
  value     = random_password.db_password.result
  sensitive = true
}
#output "app_passsword" {
#  value     = random_password.app_password[*].result
#  sensitive = true
#}
output "public_ip_address" {
  value = azurerm_public_ip.extIP
}
