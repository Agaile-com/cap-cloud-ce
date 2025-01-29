output "vpc_id" {
  description = "The ID of the Data VPC"
  value       = aws_vpc.data.id
}

output "vpc_cidr" {
  description = "The CIDR block of the Data VPC"
  value       = aws_vpc.data.cidr_block
}

output "private_subnet_ids" {
  description = "List of private subnet IDs in the Data VPC"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  value       = aws_subnet.private[*].cidr_block
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = aws_route_table.private.id
}

output "vpce_security_group_id" {
  description = "ID of VPC endpoints security group"
  value       = aws_security_group.vpce.id
}

output "availability_zones" {
  description = "List of availability zones"
  value       = data.aws_availability_zones.available.names
} 