terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# ALB & Load Balancer Resources naming conventions:
# - Application Load Balancers: ${tenant_name}-alb-tf
# - Target Groups: ${tenant_name}-alb-tg-tf

resource "aws_lb" "alb" {
  name               = "${var.tenant_name}-alb-tf"  # ✓ Follows convention
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = var.enable_deletion_protection

  tags = merge(var.common_tags, {
    Name = "${var.tenant_name}-alb-tf"  # ✓ Follows convention
    Project = "CAP"
  })

  lifecycle {
    ignore_changes = [
      tags,
      tags_all,
      security_groups,
      subnets,
      subnet_mapping
    ]
  }
}

# Add random suffix for target group names
resource "random_id" "target_group_suffix" {
  byte_length = 4
}

# Main target group with create_before_destroy
resource "aws_lb_target_group" "target_group" {
  name = "${var.tenant_name}-alb-tg-tf-${random_id.target_group_suffix.hex}"  # ✓ Follows convention
  port = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval           = 30
    matcher            = "200"
    path              = var.health_check_path
    port              = "traffic-port"
    protocol          = "HTTP"
    timeout           = 5
    unhealthy_threshold = 2
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = false
  }

  tags = merge(var.common_tags, {
    Name = "${var.tenant_name}-alb-tg-tf"  # ✓ Add Name tag following convention
  })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      health_check,
      tags
    ]
  }
}

# HTTP Listener - Redirect to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.tenant_name}-alb-tf"  # ✓ Follows convention
  })

  lifecycle {
    create_before_destroy = true
  }
}

# HTTPS Listener - Forward to target group
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  lifecycle {
    create_before_destroy = true
  }
} 