resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096

  # Only for linux systems
  provisioner "local-exec" {
    command = "echo '${tls_private_key.key_pair.private_key_pem}' > ./${var.key_pair_name}.pem"
  }
}
