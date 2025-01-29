# Keep the security group but remove the EC2 instance and IAM resources
resource "aws_security_group" "bastion" {
  name        = "${var.name_prefix}-bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-bastion-sg"
  })
}

# Security group for VPC endpoints
resource "aws_security_group" "vpce" {
  name        = "${var.name_prefix}-vpce-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [data.aws_security_group.data_vpc_bastion.id]
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-vpce-sg"
  })
}

# Get current region
data "aws_region" "current" {} 