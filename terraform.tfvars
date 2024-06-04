default_tags = {
  Application = "UNINA",
  Environment = "Example",
  Owner       = "giuseppedp",
  CostCenter  = "example",
  Provider    = "Terraform",
  Schedule    = "nada",
  AWSBackup   = "nada",
  PatchGroup  = "nada",
}

region = "eu-west-1"

vpc = {
  cidr_block_range = "10.0.0.0/16"
  subnet_public_a_cidr_block_range = "10.0.10.0/24"
  subnet_public_b_cidr_block_range = "10.0.11.0/24"
  subnet_private_a_cidr_block_range = "10.0.51.0/24"
  subnet_private_b_cidr_block_range = "10.0.52.0/24"
  subnet_db_a_cidr_block_range = "10.0.60.0/24"
  subnet_db_b_cidr_block_range = "10.0.61.0/24"

  availability_zones = {
  az-a = "eu-west-1a"
  az-b = "eu-west-1b"
  az-c = "eu-west-1c"
  }
}

key_pair_name = "UNINA-keypair"

user_data = "user-data.sh"

stackid_tf = "UNINA-EXAMPLE"