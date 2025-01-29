variable "vpc_cidr" {
  description = "CIDR block for Network VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "data_vpc_cidr" {
  description = "CIDR block of the Data VPC for Transit Gateway routing"
  type        = string
  default     = "10.2.0.0/16"  # Matches the Data VPC CIDR
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}
