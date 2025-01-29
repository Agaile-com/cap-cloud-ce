# Our single Transit Gateway - agile-dev-tgw
resource "aws_ec2_transit_gateway" "main" {
  tags = {
    Name = "agile-dev-tgw"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      tags["ManagedBy"],
      tags["Environment"]
    ]
  }
}

# Our two VPC attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "data" {
  subnet_ids         = var.data_subnet_ids
  transit_gateway_id = "tgw-06f70755505b588f0"  # Exact ID
  vpc_id            = var.data_vpc_id
  
  tags = {
    Name = "agile-dev-tgw-att-data"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "service" {
  subnet_ids         = var.service_subnet_ids
  transit_gateway_id = "tgw-06f70755505b588f0"  # Exact ID
  vpc_id            = var.service_vpc_id
  
  tags = {
    Name = "core-tgw-attachment-dev"
  }
}
