
# RDS Proxy
resource "aws_db_proxy" "aurora" {
  name                   = "${var.name_prefix}-aurora-proxy"
  debug_logging         = false
  engine_family         = "POSTGRESQL"
  idle_client_timeout   = 1800
  require_tls           = true
  role_arn             = aws_iam_role.rds_proxy.arn
  vpc_security_group_ids = [aws_security_group.aurora_proxy.id]
  vpc_subnet_ids        = var.private_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "REQUIRED"
    secret_arn  = data.aws_secretsmanager_secret.aurora_credentials.arn

  }

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-proxy"
    Purpose = "database"
  })
}

# Proxy Target Group
resource "aws_db_proxy_default_target_group" "aurora" {
  db_proxy_name = aws_db_proxy.aurora.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

# Proxy Target
resource "aws_db_proxy_target" "aurora" {
  db_cluster_identifier = aws_rds_cluster.aurora.cluster_identifier
  db_proxy_name        = aws_db_proxy.aurora.name
  target_group_name    = aws_db_proxy_default_target_group.aurora.name
}

# Proxy Endpoints
resource "aws_db_proxy_endpoint" "aurora_read" {
  db_proxy_name          = aws_db_proxy.aurora.name
  db_proxy_endpoint_name = "${var.name_prefix}-aurora-read"
  vpc_subnet_ids         = var.private_subnet_ids
  target_role           = "READ_ONLY"

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-read"
    Purpose = "database"
  })
} 