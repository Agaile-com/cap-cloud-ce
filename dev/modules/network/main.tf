# Main configuration for the network module
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Main VPC Configuration
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = merge(var.common_tags, {
    Name        = "cap-${var.environment}-vpc"
    Purpose     = "main"
    Module      = "network"
  })
}

# Private subnets
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.${count.index + 1}.0/24"
  availability_zone = "eu-central-1${count.index == 0 ? "a" : count.index == 1 ? "b" : "c"}"

  tags = merge(var.common_tags, {
    Name = "cap-${var.environment}-private-eu-central-1${count.index == 0 ? "a" : count.index == 1 ? "b" : "c"}"
    Tier = "private"
  })
}

# Public subnets
resource "aws_subnet" "public" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.10${count.index + 1}.0/24"
  availability_zone = "eu-central-1${count.index == 0 ? "a" : count.index == 1 ? "b" : "c"}"

  tags = {
    Name        = "cap-dev-public-eu-central-1${count.index == 0 ? "a" : count.index == 1 ? "b" : "c"}"
    Environment = "dev"
    Project     = "cap"
    ManagedBy   = "terraform"
    Purpose     = "main"
    Module      = "network"
    Tier        = "public"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "cap-dev-igw"
    Environment = "dev"
    Project     = "cap"
    ManagedBy   = "terraform"
    Purpose     = "main"
    Module      = "network"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "cap-dev-public-rt"
    Environment = "dev"
    Project     = "cap"
    ManagedBy   = "terraform"
    Purpose     = "main"
    Module      = "network"
    Tier        = "public"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "cap-dev-private-rt"
    Environment = "dev"
    Project     = "cap"
    ManagedBy   = "terraform"
    Purpose     = "main"
    Module      = "network"
    Tier        = "private"
  }
}

# Route Table Associations - Public
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Associations - Private
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# EIP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
    Name        = "cap-dev-nat-eip"
    Environment = "dev"
    Project     = "cap"
    ManagedBy   = "terraform"
    Purpose     = "main"
    Module      = "network"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "cap-dev-nat"
    Environment = "dev"
    Project     = "cap"
    ManagedBy   = "terraform"
    Purpose     = "main"
    Module      = "network"
  }
}

# Add NAT Gateway route to private route table
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}
