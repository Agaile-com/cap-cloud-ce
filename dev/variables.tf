# Remove or comment out these variables since we're using Secrets Manager
# variable "db_master_username" {
#   description = "Master username for Aurora cluster"
#   type        = string
#   sensitive   = true
# }

# variable "db_master_password" {
#   description = "Master password for Aurora cluster"
#   type        = string
#   sensitive   = true
# }

# Other variables...

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "cap"
    Module      = "network"
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "cap-dev"
}