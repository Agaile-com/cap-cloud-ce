# Bastion Security Group
resource "aws_security_group" "bastion" {
  name_prefix = "${var.name_prefix}-bastion-"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.data.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound for SSM"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP outbound for yum/dnf"
  }

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-bastion-sg"
    Purpose = "bastion"
  })
}

# Add AMI data source
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-minimal-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami           = "ami-085131ff43045c877"  # Keep current AMI
  instance_type = "t3.micro"
  
  # Move to private subnet
  subnet_id = aws_subnet.private[0].id
  
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name
  
  # Make sure instance has internet access via NAT Gateway
  associate_public_ip_address = false

  # Add user_data_replace_on_change to prevent instance replacement
  user_data_replace_on_change = false
  
  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              echo "Starting user data script..."
              
              # Update system
              echo "Updating system..."
              yum update -y
              
              # Remove and reinstall SSM agent with debug
              echo "Reinstalling SSM agent..."
              yum remove -y amazon-ssm-agent
              rm -rf /var/lib/amazon/ssm/*
              yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              
              # Enable debug logging for SSM agent
              echo "Enabling SSM debug logging..."
              echo "AGENT_LOG_LEVEL=debug" >> /etc/amazon/ssm/seelog.xml.template
              
              # Start and verify SSM agent
              echo "Starting SSM agent..."
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              
              # Check SSM agent status and logs
              echo "SSM agent status:"
              systemctl status amazon-ssm-agent
              echo "SSM agent logs:"
              tail -n 50 /var/log/amazon/ssm/amazon-ssm-agent.log
              echo "SSM agent errors:"
              tail -n 50 /var/log/amazon/ssm/errors.log
              
              # Test connectivity to SSM endpoints
              echo "Testing SSM connectivity..."
              nc -zv ssm.eu-central-1.amazonaws.com 443
              nc -zv ssmmessages.eu-central-1.amazonaws.com 443
              nc -zv ec2messages.eu-central-1.amazonaws.com 443
              
              # Install PostgreSQL client
              echo "Installing PostgreSQL client..."
              yum install -y postgresql15
              
              echo "User data script complete"
              EOF

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"  # Use IMDSv2
  }

  tags = merge(var.common_tags, {
    Name = "bastion-host-ng"
  })
}

# IAM Role for Session Manager
resource "aws_iam_role" "bastion" {
  name = "${var.name_prefix}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

# Attach SSM policy
resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.name_prefix}-bastion-profile"
  role = aws_iam_role.bastion.name
} 