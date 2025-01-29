# VPC Endpoints for AWS Services
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.data.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-s3-endpoint"
  })
}

# Security group for VPC endpoints
resource "aws_security_group" "vpce" {
  # Keep existing name to avoid replacement
  name        = "cap-dev-data-vpce-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.data.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description     = "Allow HTTPS from bastion host"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cap-dev-data-vpce-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "cap"
  }

  # Keep existing lifecycle block
  lifecycle {
    prevent_destroy = true
  }
}

# Interface endpoints that use the security group
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.data.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-secretsmanager-endpoint"
  })

  depends_on = [aws_security_group.vpce]
}

# CloudWatch Logs Endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.data.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-logs-endpoint"
  })

  depends_on = [aws_security_group.vpce]
}

# RDS Endpoint
resource "aws_vpc_endpoint" "rds" {
  vpc_id              = aws_vpc.data.id
  service_name        = "com.amazonaws.${var.aws_region}.rds"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-rds-endpoint"
  })

  depends_on = [aws_security_group.vpce]
}

# SSM VPC Endpoints
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.data.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-ssm-endpoint"
  })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.data.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-ssmmessages-endpoint"
  })
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.data.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-data-ec2messages-endpoint"
  })
} 