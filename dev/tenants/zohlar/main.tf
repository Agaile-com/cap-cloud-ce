provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Environment = "dev"  # Explicitly set to dev
    ManagedBy   = "terraform"
    Project     = "CAP"
  }
  
  container_image_base = "533267288999.dkr.ecr.eu-central-1.amazonaws.com"
  container_image     = "${local.container_image_base}/cap-frontend:zohlar"
}

# Data sources for VPC and subnets
data "aws_vpc" "core" {
  filter {
    name   = "tag:Name"
    values = ["cap-dev-vpc"]
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

data "aws_route53_zone" "main" {
  name         = "widget.agaile.com"
  private_zone = false
}

data "aws_acm_certificate" "main" {
  domain      = "*.widget.agaile.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

# Security Module
module "security" {
  source = "./../../modules/security"

  environment    = var.environment
  tenant_name    = var.tenant_name
  vpc_id         = data.aws_vpc.core.id
  container_port = 3000
  aws_region     = var.aws_region
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
  container_port            = 3000
  health_check_path         = var.health_check_path
  enable_deletion_protection = false
  common_tags               = merge(local.common_tags, {
    Name = "${var.tenant_name}-alb-tf"
  })
}

# ECS Module
module "ecs" {
  source = "./../../modules/ecs"

  tenant_name              = var.tenant_name
  environment              = var.environment
  aws_region               = var.aws_region
  container_image          = local.container_image
  container_port           = 3000
  container_environment    = [
    {
      name  = "PORT"
      value = "3000"
    },
    {
      name  = "API_URL"
      value = "https://api.widget.agaile.com"
    },
    {
      name  = "APP_URL"
      value = "https://${var.tenant_name}.widget.agaile.com"
    }
  ]
  
  container_secrets = [
    {
      name      = "LANGCHAIN_API_KEY"
      valueFrom = "${aws_secretsmanager_secret.zohlar_env.arn}:LANGCHAIN_API_KEY::"
    },
    {
      name      = "LANGGRAPH_API_URL"
      valueFrom = "${aws_secretsmanager_secret.zohlar_env.arn}:LANGGRAPH_API_URL::"
    },
    {
      name      = "NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID"
      valueFrom = "${aws_secretsmanager_secret.zohlar_env.arn}:NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID::"
    }
  ]
  task_cpu                 = var.task_cpu
  task_memory              = var.task_memory
  service_desired_count    = var.service_desired_count
  private_subnet_ids       = data.aws_subnets.private.ids
  ecs_tasks_security_group_id = module.security.ecs_tasks_security_group_id
  target_group_arn         = module.alb.target_group_arn
  ecs_task_execution_role_arn = module.security.ecs_task_execution_role_arn
  common_tags             = local.common_tags
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