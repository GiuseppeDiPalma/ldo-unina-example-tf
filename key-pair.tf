#Resource to create a SSH private key
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Resource to Create Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.my_key.public_key_openssh

  # Only for linux systems
  provisioner "local-exec" {
    command = "echo '${tls_private_key.my_key.private_key_pem}' > ./${var.key_pair_name}.pem"
  }
}
