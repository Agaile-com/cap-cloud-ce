variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
} 