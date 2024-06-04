output "aws_ec2_ami_id" {
  description = "The AMI ID of the Amazon Linux 2 AMI"
  value       = data.aws_ami.amzn2.id
}

output "ec2_first_app_private_ip" {
  description = "Private Ip of the EC2 instances"
  value       = aws_instance.first_app.private_ip
}

output "ec2_second_app_private_ip" {
  description = "Private Ip of the EC2 instances"
  value       = [aws_instance.second_app.private_ip]
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = aws_lb.alb_prod.dns_name
}
