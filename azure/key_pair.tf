resource "random_string" "random" {
  length           = 6
  special          = true
  override_special = "/@£$"
}

# resource "azurerm_key_vault_access_policy" "access_policy" {
#   key_vault_id = azurerm_key_vault.key_vault.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id

#     secret_permissions = [
#       "Set", "Get", "Delete", "Purge", "List",  ]
# }

resource "azurerm_key_vault" "key_vault" {
  name                = "myvault-${random_string.random.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
    "Set", "Get", "Delete", "Purge", "List", ]
  }
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.key_pair_name
  value        = tls_private_key.key_pair.public_key_openssh
  key_vault_id = azurerm_key_vault.key_vault.id

  # Only for linux systems
  provisioner "local-exec" {
    command = "echo '${tls_private_key.key_pair.private_key_pem}' > ./${var.key_pair_name}.pem"
  }
}
