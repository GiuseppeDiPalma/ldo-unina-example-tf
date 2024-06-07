output "az_key_vault_name" {
  description = "The name of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "az_public_ip" {
  description = "The public IP address of the Azure VM"
  value       = azurerm_public_ip.public_ip.ip_address
}
