variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "container_image" {
  description = "Docker image to run in the ECS cluster"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "container_environment" {
  description = "Environment variables for the container"
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory for the ECS task"
  type        = number
}

variable "service_desired_count" {
  description = "Number of instances of the task to run"
  type        = number
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_tasks_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
} 