# Security Group for Service VPC to Data VPC communication
resource "aws_security_group" "service_to_data" {
  name        = "service-to-data-sg"
  description = "Security group for Service VPC to Data VPC communication"
  vpc_id      = var.service_vpc_id

  tags = merge(var.common_tags, {
    Name = "agile-dev-service-to-data-sg"
  })
}

# Security Group for Data VPC to Service VPC communication
resource "aws_security_group" "data_to_service" {
  name        = "data-to-service-sg"
  description = "Security group for Data VPC to Service VPC communication"
  vpc_id      = var.data_vpc_id

  tags = merge(var.common_tags, {
    Name = "agile-dev-data-to-service-sg"
  })
}

# Rules for Service VPC to Data VPC
resource "aws_security_group_rule" "service_to_data" {
  type              = "egress"
  from_port         = 5432  # PostgreSQL
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.data_vpc_cidr]
  security_group_id = aws_security_group.service_to_data.id
}

# Rules for Data VPC to Service VPC
resource "aws_security_group_rule" "data_to_service" {
  type              = "ingress"
  from_port         = 5432  # PostgreSQL
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.service_vpc_cidr]
  security_group_id = aws_security_group.data_to_service.id
} 