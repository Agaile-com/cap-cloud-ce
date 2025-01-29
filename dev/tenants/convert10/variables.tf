variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
  default     = "convert10"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "container_image" {
  description = "Container image to use"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 3000
}

variable "container_environment" {
  description = "Environment variables for the container"
  type        = list(map(string))
  default     = []
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task in MB"
  type        = number
  default     = 512
}

variable "service_desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "Path for ALB health check"
  type        = string
  default     = "/"
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
  default     = null  # We're using data source instead
}

variable "cloudfront_certificate_arn" {
  description = "ARN of the CloudFront certificate"
  type        = string
  default     = null  # Not using CloudFront
}