variable "vpc_cidr" {
  description = "CIDR block for Data VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24"
  ]
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
}

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
} 