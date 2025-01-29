# Get the existing bastion security group from data_vpc module
data "aws_security_group" "data_vpc_bastion" {
  name = "${var.name_prefix}-bastion-sg"  # This should match the name in data_vpc module
  vpc_id = var.vpc_id
} 