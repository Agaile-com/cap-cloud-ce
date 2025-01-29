variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# VPC IDs
variable "service_vpc_id" {
  type        = string
  description = "ID of the Service VPC"
}

variable "data_vpc_id" {
  type        = string
  description = "ID of the Data VPC"
}

# Subnet IDs
variable "service_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Service VPC attachment"
}

variable "data_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Data VPC attachment"
}

# CIDR Blocks
variable "service_vpc_cidr" {
  type        = string
  description = "CIDR block for Service VPC"
  default     = "10.0.0.0/16"
}

variable "data_vpc_cidr" {
  type        = string
  description = "CIDR block for Data VPC"
  default     = "10.2.0.0/16"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "CAP"
  }
}

variable "service_vpc_route_table_id" {
  description = "ID of the Service VPC route table"
  type        = string
}

variable "data_vpc_route_table_id" {
  description = "ID of the Data VPC route table"
  type        = string
} 