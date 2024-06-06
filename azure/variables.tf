variable "region" {
  description = "The AWS region to deploy to"
}

variable "vpc" {
  description = "All value related to the VPC"
}

variable "default_tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
}

variable "stackid_tf" {
  description = "The stack id to use for all resources"
}

variable "key_pair_name" {
  description = "The name of the key pair to use for the EC2 instances"
}

variable "user_data" {
  description = "The path to the user data script to use for the EC2 instances"
}
