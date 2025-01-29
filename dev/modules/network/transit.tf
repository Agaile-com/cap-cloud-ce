# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = "Main Transit Gateway for VPC connectivity"
  
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  
  tags = merge(local.network_tags, {
    Name = local.transit_gateway_name
  })
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "main" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-tgw-rt"
  })
}

# VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id            = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-tgw-attachment"
  })
}

# Route Table Association
resource "aws_ec2_transit_gateway_route_table_association" "main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

# Route Table Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

# Route from private subnets to Transit Gateway
resource "aws_route" "private_to_tgw" {
  route_table_id         = aws_route_table.private.id  # Removed [count.index]
  destination_cidr_block = var.data_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}
