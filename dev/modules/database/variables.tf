variable "vpc_id" {
  description = "ID of the VPC where database resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for database resources"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "cap"
  }
}

variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
}

variable "data_vpc_private_subnet_ids" {
  description = "List of private subnet IDs in the data VPC for Aurora"
  type        = list(string)
  default     = [
    "subnet-0197df41affb2d92d",
    "subnet-0521f8466a40b394c",
    "subnet-03b10924d502d91b6"
  ]
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to connect to Aurora"
  type        = list(string)
  default     = []
}

variable "transit_gateway_route_table_id" {
  description = "ID of the transit gateway route table"
  type        = string
  default     = null
} 
variable "cluster_identifier" {
  type = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-0669b163befffbdfc"  # Update this for your region
}