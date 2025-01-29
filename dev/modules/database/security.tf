# Security group for Aurora
resource "aws_security_group" "aurora" {
  name_prefix = "${var.environment}-aurora-"
  description = "Security group for Aurora cluster"
  vpc_id      = var.vpc_id

  # Remove the ingress rules from here since we're managing them separately
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-sg"
    Purpose = "database"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Keep the separate security group rules
resource "aws_security_group_rule" "aurora_ingress_ecs" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]  # Main VPC CIDR where ECS services run
  security_group_id = aws_security_group.aurora.id
  description       = "Allow PostgreSQL access from ECS services"
}

resource "aws_security_group_rule" "aurora_ingress_bastion" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.data_vpc_bastion.id
  security_group_id        = aws_security_group.aurora.id
  description              = "Allow PostgreSQL access from Bastion host"
}

# Aurora Proxy Security Group
resource "aws_security_group" "aurora_proxy" {
  name        = "${var.name_prefix}-aurora-proxy-sg"
  description = "Security group for Aurora RDS Proxy"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.aurora_shared.id]
  }

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-proxy-sg"
    Purpose = "database"
  })
}

# Shared Security Group for Application Access
resource "aws_security_group" "aurora_shared" {
  name        = "${var.name_prefix}-aurora-shared-sg"
  description = "Shared security group for Aurora access"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-shared-sg"
    Purpose = "database"
  })
} 