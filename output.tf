output "aws_ec2_ami_id" {
  description = "The AMI ID of the Amazon Linux 2 AMI"
  value       = data.aws_ami.amzn2.id
}
