output "vmss_public_ip" {
  value = azurerm_public_ip.pub_ip
}

output "VMSS_admin_user" {
  value = var.admin_user
}

output "VMSS_admin_password" {
  value = var.admin_password
}

output "DB_username" {
  value = var.db_admin_user
}

output "DB_admin_password" {
  value = var.db_admin_password
}


