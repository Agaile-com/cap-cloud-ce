# RDS Proxy Secret (existing)
resource "aws_secretsmanager_secret" "proxy_secret" {
  name                           = "agaile-rds-proxy-secret"
  recovery_window_in_days        = 0
  force_overwrite_replica_secret = true

  tags = {
    Environment = "Production"
    ManagedBy   = "terraform"
    Name        = "agaile-rds-proxy-secret"
    Project     = "CAP"
    Terraform   = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}
