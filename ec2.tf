data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "first_app" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"

  key_name  = aws_key_pair.generated_key.key_name
  subnet_id = aws_subnet.private_a.id

  security_groups      = [aws_security_group.sg-ec2.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-iam-profile.id

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # ebs_block_device {
  #   device_name           = "/dev/sdh"
  #   volume_size           = 80
  #   volume_type           = "gp3"
  #   delete_on_termination = true
  # }

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update
  #             sudo apt install -y nginx
  #             sudo systemctl start nginx
  #             sudo systemctl enable nginx
  #             EOF

  user_data = file(var.user_data)

  tags = {
    Name = "${var.stackid_tf}-first-app"
  }
}

resource "aws_instance" "second_app" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"

  key_name  = aws_key_pair.generated_key.key_name
  subnet_id = aws_subnet.private_b.id

  iam_instance_profile = aws_iam_instance_profile.ec2-iam-profile.id
  security_groups      = [aws_security_group.sg-ec2.id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # ebs_block_device {
  #   device_name           = "/dev/sdh"
  #   volume_size           = 80
  #   volume_type           = "gp3"
  #   delete_on_termination = true
  # }

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update
  #             sudo apt install -y nginx
  #             sudo systemctl start nginx
  #             sudo systemctl enable nginx
  #             EOF
  user_data = file(var.user_data)

  tags = {
    Name = "${var.stackid_tf}-second-app"
  }
}

# Create role
resource "aws_iam_role" "ec2-iam-role" {
  name               = "${var.stackid_tf}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role-policy.json
}

# Create policy for SSM with data block
data "aws_iam_policy_document" "ec2-assume-role-policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach-ssm-policy-to-role" {
  role       = aws_iam_role.ec2-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# Create instance profile and attach role
resource "aws_iam_instance_profile" "ec2-iam-profile" {
  name = "${var.stackid_tf}-iam-profile"
  role = aws_iam_role.ec2-iam-role.name
}

# Security Group for ALB (HTTP)
resource "aws_security_group" "sg-ec2" {
  name   = "${var.stackid_tf}-sg-ec2"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
