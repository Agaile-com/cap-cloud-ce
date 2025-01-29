variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "585008045756"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
  default     = "rooftopsolar"
}

# ALB Variables
variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
  default     = null  # We're using data source instead
}

variable "health_check_path" {
  description = "Path for ALB health check"
  type        = string
  default     = "/"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

# ECS Variables
variable "container_image" {
  description = "Container image to use"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 3000
}

variable "task_cpu" {
  description = "CPU units for the task (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task in MB"
  type        = number
  default     = 512
}

variable "service_desired_count" {
  description = "Desired number of tasks running"
  type        = number
  default     = 1
}

variable "container_environment" {
  description = "Environment variables for the container"
  type        = list(map(string))
  default     = []
} 