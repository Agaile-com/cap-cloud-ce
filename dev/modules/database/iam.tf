# IAM Role for RDS Proxy
resource "aws_iam_role" "rds_proxy" {
  name = "rds-proxy-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })

  tags = merge(var.common_tags, {
    Name    = "rds-proxy-role-${var.environment}"
    Purpose = "database"
  })
}

# RDS Proxy Policy
resource "aws_iam_role_policy" "rds_proxy" {
  name = "rds-proxy-policy-${var.environment}"
  role = aws_iam_role.rds_proxy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = concat(
          [data.aws_secretsmanager_secret.aurora_credentials.arn],
          [data.aws_secretsmanager_secret.aurora_proxy.arn],
          aws_secretsmanager_secret.aurora_credentials[*].arn
        )
      }
    ]
  })
}

# IAM Role for Enhanced Monitoring
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name = "${var.name_prefix}-rds-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-rds-monitoring"
    Purpose = "monitoring"
  })
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
} 