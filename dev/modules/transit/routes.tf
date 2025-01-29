# Transit Gateway Routes
resource "aws_ec2_transit_gateway_route" "service_to_data" {
  destination_cidr_block         = var.data_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.data.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.service.id
}

resource "aws_ec2_transit_gateway_route" "data_to_service" {
  destination_cidr_block         = var.service_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.service.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.data.id
}

# Route Table Associations
resource "aws_ec2_transit_gateway_route_table_association" "service" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.service.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.service.id
}

resource "aws_ec2_transit_gateway_route_table_association" "data" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.data.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.data.id
}

# Route Table Propagations
resource "aws_ec2_transit_gateway_route_table_propagation" "service_to_data" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.data.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.service.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "data_to_service" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.service.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.data.id
}

# Add routes in VPC route tables
resource "aws_route" "service_to_data" {
  route_table_id         = var.service_vpc_route_table_id
  destination_cidr_block = var.data_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "data_to_service" {
  route_table_id         = var.data_vpc_route_table_id
  destination_cidr_block = var.service_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
} 