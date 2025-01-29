# Keep only database-specific resources
locals {
  cluster_name       = "dev-aurora-cluster"
  subnet_group_name  = "dev-aurora-subnet-group"
  security_group_name = "aurora-dev"
  data_vpc_id        = "vpc-0eba7afb9b7643d7f"
  
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "CAP"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "aurora" {
  name        = "${var.environment}-aurora-subnet-group"
  description = "Subnet group for Aurora database"
  subnet_ids  = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-subnet-group"
    Purpose = "database"
  })
}

# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "aurora" {
  cluster_identifier     = "dev-aurora-cluster"
  engine                = "aurora-postgresql"
  engine_version        = "15.4"
  database_name         = "agailedb"
  master_username       = jsondecode(data.aws_secretsmanager_secret_version.aurora_credentials.secret_string)["username"]
  master_password       = jsondecode(data.aws_secretsmanager_secret_version.aurora_credentials.secret_string)["password"]
  backup_retention_period = 7
  db_subnet_group_name  = aws_db_subnet_group.aurora.name
  
  vpc_security_group_ids = [aws_security_group.aurora.id]
  
  iam_database_authentication_enabled = true
  
  serverlessv2_scaling_configuration {
    max_capacity = 1
    min_capacity = 0.5
  }

  skip_final_snapshot = true
  
  tags = var.common_tags
}

# Aurora Instance
resource "aws_rds_cluster_instance" "aurora" {
  identifier         = "${var.environment}-aurora-instance-1"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
  
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn
  monitoring_interval = 60

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-aurora-1"
    Purpose = "database"
  })
}

