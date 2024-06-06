#################
# GENERAL       #
#################

# Define a fixed version of the AWS provider for consistency
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

# Define a constant variable for the AWS region
variable "AWS_REGION" {
  description = "AWS Region to deploy the infrastructure to"
  default     = "HERO-INFRA-VAR-AWS-REGION"
}

#################
# NETWORKING    #
#################

# Define the VPC for the infrastructure
resource "aws_vpc" "general" {
  cidr_block = "10.0.0.0/16"
}

# Define a DNS configuration to be used by the VPC so that it can resolve domain names
resource "aws_vpc_dhcp_options" "dns" {
  domain_name_servers = ["AmazonProvidedDNS"]
}
resource "aws_vpc_dhcp_options_association" "dns_association" {
  vpc_id          = aws_vpc.general.id
  dhcp_options_id = aws_vpc_dhcp_options.dns.id
}

# Define a subnet for the VPC which will contain all the resources
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.general.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create an internet gateway to allow the VPC to connect to the internet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.general.id
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.general.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

#################
# SECURITY      #
#################

# Define a security group for the ECS instances to allow all traffic in and out
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Security group for ECS instances to allow all traffic"
  vpc_id      = aws_vpc.general.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#################
# ECS           #
#################

# Define a single ECS Cluster to be used by all the services
resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}

# Define a role for the ECS tasks to assume when running
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
