terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

# Use S3 Bucket created as the backend for Terraform state
terraform {
  backend "s3" {
    bucket = "hero-infra-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  # TODO: Dynamically set the region
  region = "eu-west-2"
}

resource "aws_ecs_service" "service" {
    name            = "service"
    cluster         = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    network_configuration {
        subnets         = aws_subnet.subnet.*.id
        security_groups = [aws_security_group.security_group.id]
    }
}
