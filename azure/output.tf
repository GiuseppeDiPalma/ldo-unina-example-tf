output "az_public_ip" {
  description = "The public IP address of the Azure VM"
  value       = azurerm_public_ip.public_ip.ip_address
}
