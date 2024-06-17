data "template_file" "cloud_init_config" {
  template = file("${path.module}/cloud_init_config.yaml")
}

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

  # https://az-vm-image.info/
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

  custom_data = base64encode(<<CLOUD_INIT
#cloud-config
write_files:
-   content: |
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
 
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
      <head>
        <title>Nginx HTTP Server on AZURE</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      </head>
      <body>
      <h1>Welcome!</h1>
      <h2>Welcome!</h2>
        <div>Welcome to <b>nginx</b> on Oracle Cloud Infrastructure!</div>
      </body>
      </html>
    owner: opc:opc
    path: /home/opc/index.html
runcmd:
-   /bin/yum install -y nginx
-   /bin/systemctl start nginx
-   /bin/firewall-offline-cmd --add-port=80/tcp
-   /bin/systemctl restart firewalld
-   cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.original.html
-   cat /home/opc/index.html > /usr/share/nginx/html/index.html
  CLOUD_INIT
  )
}
