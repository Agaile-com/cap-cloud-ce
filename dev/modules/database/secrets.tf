# Proxy secret
data "aws_secretsmanager_secret" "aurora_proxy" {
  name = "dev/aurora/proxy"  # Using existing secret
}

data "aws_secretsmanager_secret_version" "aurora_proxy" {
  secret_id = data.aws_secretsmanager_secret.aurora_proxy.id
}

# Get the JSON values from secrets
locals {
  aurora_proxy = jsondecode(data.aws_secretsmanager_secret_version.aurora_proxy.secret_string)
}

# Use existing secret if it exists
data "aws_secretsmanager_secret" "aurora_credentials" {
  name = "${var.environment}-aurora-credentials"
}

data "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = data.aws_secretsmanager_secret.aurora_credentials.id
}

# Generate random password for Aurora master user
resource "random_password" "master" {
  length           = 16
  special          = true
  numeric          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Only create the secret if it doesn't exist
resource "aws_secretsmanager_secret" "aurora_credentials" {
  count = data.aws_secretsmanager_secret.aurora_credentials.id == null ? 1 : 0
  name  = "${var.environment}-aurora-credentials"
  
  tags = merge(var.common_tags, {
    Name = "${var.environment}-aurora-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = try(aws_secretsmanager_secret.aurora_credentials[0].id, data.aws_secretsmanager_secret.aurora_credentials.id)
  secret_string = jsonencode({
    username = "databaseadmin"
    password = random_password.master.result
  })
} 