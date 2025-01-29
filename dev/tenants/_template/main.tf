provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Environment = var.environment
    Tenant     = var.tenant_name
    ManagedBy  = "terraform"
  }
  
  container_image_base = "585008045756.dkr.ecr.eu-central-1.amazonaws.com"
  container_image     = "${local.container_image_base}/${var.tenant_name}-cap-engine:latest"
}

# Data sources for VPC and subnets
data "aws_vpc" "core" {
  filter {
    name   = "tag:Name"
    values = ["cap-${var.environment}-vpc"]
  }

  filter {
    name   = "tag:Purpose"
    values = ["main"]
  }

  filter {
    name   = "tag:Module"
    values = ["network"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.core.id]
  }
  tags = {
    Tier = "public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.core.id]
  }
  tags = {
    Tier = "private"
  }
}

# Security Module
module "security" {
  source = "./../../modules/security"

  environment    = var.environment
  tenant_name    = var.tenant_name
  vpc_id         = data.aws_vpc.core.id
  container_port = var.container_port
  common_tags    = local.common_tags
}

# ALB Module
module "alb" {
  source = "./../../modules/alb"

  environment                = var.environment
  tenant_name               = var.tenant_name
  vpc_id                    = data.aws_vpc.core.id
  public_subnet_ids         = data.aws_subnets.public.ids
  alb_security_group_id     = module.security.alb_security_group_id
  certificate_arn           = data.aws_acm_certificate.main.arn
  container_port            = var.container_port
  health_check_path         = var.health_check_path
  enable_deletion_protection = false
  common_tags               = merge(local.common_tags, {
    Name = "${var.tenant_name}-alb-tf"
  })
}

# ECS Module
module "ecs" {
  source = "./../../modules/ecs"

  tenant_name               = var.tenant_name
  environment              = var.environment
  aws_region               = var.aws_region
  container_image          = var.container_image
  container_port           = var.container_port
  container_environment    = var.container_environment
  task_cpu                = var.task_cpu
  task_memory             = var.task_memory
  service_desired_count   = var.service_desired_count
  private_subnet_ids      = data.aws_subnets.private.ids
  ecs_tasks_security_group_id = module.security.ecs_tasks_security_group_id
  target_group_arn        = module.alb.target_group_arn
  ecs_task_execution_role_arn = module.security.ecs_task_execution_role_arn
  common_tags            = local.common_tags
}

# Base Module for DynamoDB and S3
module "base" {
  source = "../../../../modules/tenant/base"

  environment     = var.environment
  tenant_name    = var.tenant_name
  domain_names   = ["${var.tenant_name}.widget.agaile.com"]
  certificate_arn = var.certificate_arn
  route53_zone_id = data.aws_route53_zone.main.zone_id
  common_tags    = local.common_tags
}

# Route53 record for ALB
resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.tenant_name}.${data.aws_route53_zone.main.name}"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
} 