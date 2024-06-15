provider "aws" {
  region = "eu-central-1"
}

# Security Group
resource "aws_security_group" "bp2_hosting_backend_sg" {
    name        = "bp2-hosting-backend-sg"
    description = "Allow HTTP, HTTPS and SSH traffic"
    vpc_id      = "vpc-09e61af5bb6aafa26"

    ingress {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
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

# Base64 encode User Data script
locals {
    user_data_script = <<-EOT
        #!/bin/bash

        sudo yum update -y

        sudo yum install docker -y
        sudo service docker start
        sudo usermod -a -G docker ec2-user

        sudo dnf install libxcrypt-compat -y

        sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        sudo chmod +x /usr/local/bin/docker-compose

        # Create a symbolic link to /usr/bin
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

        cd /home/ec2-user/
        mkdir project
        cd ./project
        curl -L "https://raw.githubusercontent.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/main/docker/prod/docker-compose.yml" -o docker-compose.yml

        sudo docker-compose up -d
    EOT

    user_data_base64 = base64encode(local.user_data_script)
}

# Launch Template
resource "aws_launch_template" "ect_bp2_hosting_backend" {
    name          = "ec2t-bp2-hosting-backend"
    image_id      = "ami-00cf59bc9978eb266"
    instance_type = "t2.micro"
    key_name      = "tmp-key-pair"

    vpc_security_group_ids = [aws_security_group.bp2_hosting_backend_sg.id]

    user_data = local.user_data_base64
}

# Target Group
resource "aws_lb_target_group" "tg_bp2_hosting_backend" {
    name     = "tg-bp2-hosting-backend"
    port     = 80
    protocol = "HTTP"
    vpc_id   = "vpc-09e61af5bb6aafa26"
}

# Load Balancer
resource "aws_lb" "alb_bp2_hosting_backend" {
    name               = "alb-bp2-hosting-backend"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.bp2_hosting_backend_sg.id]
    subnets            = ["subnet-075437f53bad1c0e3",
                          "subnet-0f5bbc4112f613d16",
                          "subnet-01120a3503e1fe9a4"]

    enable_deletion_protection = false
}

# Load Balancer Listener for HTTP
resource "aws_lb_listener" "listener_http_bp2_hosting_backend" {
  load_balancer_arn = aws_lb.alb_bp2_hosting_backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_bp2_hosting_backend.arn
  }
}

# Load Balancer Listener for HTTPS
resource "aws_lb_listener" "listener_https_bp2_hosting_backend" {
    load_balancer_arn = aws_lb.alb_bp2_hosting_backend.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = "arn:aws:acm:eu-central-1:533267024986:certificate/2412b429-1dd0-4850-a11d-6692007d62b9"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg_bp2_hosting_backend.arn
    }
}

# Autoscaling Group
resource "aws_autoscaling_group" "asg_bp2_hosting_backend" {
    name                 = "asg-bp2-hosting-backend"
    desired_capacity     = 4
    max_size             = 5
    min_size             = 3
    vpc_zone_identifier  = ["subnet-075437f53bad1c0e3",
                            "subnet-0f5bbc4112f613d16",
                            "subnet-01120a3503e1fe9a4"]

    launch_template {
        id      = aws_launch_template.ect_bp2_hosting_backend.id
        version = "$Latest"
    }

    target_group_arns = [aws_lb_target_group.tg_bp2_hosting_backend.arn]
}

# Route 53 Record
resource "aws_route53_record" "bp2_hosting_backend" {
  zone_id = "Z0537675234U5T8AE6L76"
  name    = "bp2.enricogoerlitz.com"
  type    = "A"

  alias {
    name                   = aws_lb.alb_bp2_hosting_backend.dns_name
    zone_id                = aws_lb.alb_bp2_hosting_backend.zone_id
    evaluate_target_health = true
  }
}
