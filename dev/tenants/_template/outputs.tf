output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = module.alb.target_group_arn
}

output "service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.service_name
}

output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = module.ecs.task_definition_arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.ecs.cloudwatch_log_group_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "dynamodb_tables" {
  description = "DynamoDB table names"
  value = {
    assistant_configs = module.base.assistant_configs_table_name
    prompt_template  = module.base.prompt_template_table_name
    chat_history    = module.base.chat_history_table_name
  }
}

output "s3_bucket" {
  description = "S3 bucket information"
  value = {
    name = module.base.s3_bucket_name
    website_endpoint = module.base.s3_bucket_website_endpoint
  }
}

output "security_groups" {
  description = "Security group IDs"
  value = {
    alb_security_group_id = module.security.alb_security_group_id
    ecs_tasks_security_group_id = module.security.ecs_tasks_security_group_id
  }
} 