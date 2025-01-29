output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB"
  value       = aws_lb.alb.zone_id
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.target_group.arn
}

output "target_group_name" {
  description = "The name of the Target Group"
  value       = aws_lb_target_group.target_group.name
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
} 