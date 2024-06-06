resource "aws_lb" "alb_prod" {
  name               = "${var.stackid_tf}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets = [
    "${aws_subnet.public_a.id}",
    "${aws_subnet.public_b.id}"
    # ,"${aws_subnet.public_c.id}"
  ]

  enable_deletion_protection = false

}

# Security Group for ALB (HTTP and HTTPS)
resource "aws_security_group" "alb-sg" {
  name   = "${var.stackid_tf}-alb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "sample_tg" {
  name        = "sample-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id

  stickiness {
    enabled         = false
    type            = "lb_cookie"
    cookie_duration = 120
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    port                = 80
  }
}

## DA SBLOCCARE QUANDO AVREMO CERTIFICATO DEL CLIENTE

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.alb_prod.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = " " # TBD

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.sample_tg.arn
#   }
# }

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb_prod.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_tg.arn
  }
}

# attack ec2 to target group
resource "aws_lb_target_group_attachment" "sample_first_tg_attachment" {
  target_group_arn = aws_lb_target_group.sample_tg.arn
  target_id        = aws_instance.first_app.id
  port             = 80
}

# attack ec2 to target group
resource "aws_lb_target_group_attachment" "sample_second_tg_attachment" {
  target_group_arn = aws_lb_target_group.sample_tg.arn
  target_id        = aws_instance.second_app.id
  port             = 80
}
