# main.tf
provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "cap-tf-state-org"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
  }
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

locals {
  environment = "dev"
  common_tags = {
    Environment = local.environment
    ManagedBy   = "terraform"
    Project     = "CAP"
  }
}

module "data_vpc" {
  source = "./modules/data_vpc"
  
  aws_region  = var.aws_region
  environment = var.environment
  name_prefix = "cap-${var.environment}"
  common_tags = local.common_tags
}

module "network" {
  source = "./modules/network"

  vpc_cidr     = "10.1.0.0/16"
  aws_region   = var.aws_region
  environment  = var.environment
  common_tags  = var.common_tags
  name_prefix  = var.name_prefix
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = "Main Transit Gateway for ${local.environment}"
  
  tags = merge(local.common_tags, {
    Name = "cap-${local.environment}-tgw"
  })
}

# Transit Gateway VPC Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids         = module.network.private_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id            = module.network.vpc_id
  
  tags = merge(local.common_tags, {
    Name = "cap-${local.environment}-main-tgw-attachment"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "data" {
  subnet_ids         = module.data_vpc.private_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id            = module.data_vpc.vpc_id
  
  tags = merge(local.common_tags, {
    Name = "cap-${local.environment}-data-tgw-attachment"
  })
}

# Instead of creating new routes, import the existing ones
# resource "aws_route" "main_to_data" { ... }
# resource "aws_route" "data_to_main" { ... }

module "database" {
  source = "./modules/database"
  cluster_identifier = "dev-aurora-cluster"  # Replace with your dev cluster identifier


  vpc_id             = module.data_vpc.vpc_id
  private_subnet_ids = module.data_vpc.private_subnet_ids
  environment        = var.environment
  common_tags        = var.common_tags
  name_prefix        = var.name_prefix
}

# Comment out route resources until transit module is ready
# resource "aws_route" "main_to_data" { ... }
# resource "aws_route" "data_to_main" { ... }

# Add monitoring module
module "monitoring" {
  source = "./modules/monitoring"

  environment       = var.environment
  name_prefix      = var.name_prefix
  common_tags      = local.common_tags
  ecs_cluster_name = "cap-${var.environment}-ecs-cluster"
  ecs_service_name = "cap-${var.environment}-ecs-service"
}



