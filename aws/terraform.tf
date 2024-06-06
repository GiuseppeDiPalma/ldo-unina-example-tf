terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
  profile                  = "personal"

  default_tags {
    tags = {
      Application = "${var.default_tags["Application"]}"
      Environment = "${var.default_tags["Environment"]}"
      Owner       = "${var.default_tags["Owner"]}"
      CostCenter  = "${var.default_tags["CostCenter"]}"
      Provider    = "${var.default_tags["Provider"]}"
      Schedule    = "${var.default_tags["Schedule"]}"
      AWSBackup   = "${var.default_tags["AWSBackup"]}"
      PatchGroup  = "${var.default_tags["PatchGroup"]}"
    }
  }
}
