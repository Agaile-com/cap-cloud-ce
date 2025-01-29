locals {
  # Common tags to be applied to all resources
  network_tags = merge(
    var.common_tags,
    {
      Module      = "network"
      Environment = var.environment
    }
  )

  # VPC configurations
  vpc_name = "cap-${var.environment}-vpc"
  
  # Subnet naming
  subnet_names = {
    private = [for i, az in var.availability_zones : "cap-${var.environment}-private-${az}"]
    public  = [for i, az in var.availability_zones : "cap-${var.environment}-public-${az}"]
  }

  # Transit Gateway naming
  transit_gateway_name = "cap-${var.environment}-tgw"
  
  # VPC Endpoint naming pattern
  endpoint_name_prefix = "cap-${var.environment}-vpce"

  # Current region data
  region_name = var.aws_region
  
  # Availability zone count
  az_count = length(var.availability_zones)
}
