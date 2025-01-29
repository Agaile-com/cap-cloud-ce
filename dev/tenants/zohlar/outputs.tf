output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = module.alb.alb_zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.alb.target_group_arn
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = module.security.alb_security_group_id
}

output "ecs_tasks_security_group_id" {
  description = "ID of the ECS tasks security group"
  value       = module.security.ecs_tasks_security_group_id
}

output "service_name" {
  description = "The name of the Zohlar ECS service"
  value       = module.ecs.service_name
}

output "task_definition_arn" {
  description = "The ARN of the Zohlar task definition"
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