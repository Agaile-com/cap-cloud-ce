output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_rds_cluster.aurora.endpoint
}

output "db_instance_port" {
  description = "The port the RDS instance is listening on"
  value       = aws_rds_cluster.aurora.port
}

output "db_instance_username" {
  description = "The master username for the RDS instance"
  value       = aws_rds_cluster.aurora.master_username
  sensitive   = true
}

output "db_cluster_identifier" {
  description = "The cluster identifier"
  value       = aws_rds_cluster.aurora.cluster_identifier
}

output "db_security_group_id" {
  description = "The security group ID for the RDS cluster"
  value       = aws_security_group.aurora.id
}
output "secret_arn" {
  value = data.aws_secretsmanager_secret.aurora_credentials.arn
}