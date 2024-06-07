# data "azurerm_image" "ubuntu" {
#   name                = "centos-7_9"
#   resource_group_name = azurerm_resource_group.rg.name
# }

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "my-first-terraform-VM"
  computer_name         = "my-first-terraform-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.private_a_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "my-first-terraform-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5-gen2"
    version   = "latest"
  }

  admin_username                  = "secureadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "secureadmin"
    public_key = tls_private_key.key_pair.public_key_openssh
  }

  custom_data = base64encode(var.user_data)
}
