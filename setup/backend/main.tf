terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

variable "AWS_REGION" {
  type = string
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "hero-infra-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB Table for Terraform State Lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "hero-infra-terraform-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Additional S3 Bucket to store the Hero Infra project configuration
resource "aws_s3_bucket" "hero_infra_config" {
  bucket = "hero-infra-config"

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "hero_infra_config" {
  bucket = aws_s3_bucket.hero_infra_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Add the default Hero Infra config into the bucket
resource "aws_s3_object" "hero_infra_default_config" {
  bucket  = aws_s3_bucket.hero_infra_config.id
  key = "config.json"
  content = <<EOF
{
  "region": "${var.AWS_REGION}",
  "version": "0.0.1",
  "services": {
    "hero-infra": {
      "name": "hero-infra",
      "source": {
        "source": "dockerhub",
        "url": "thimovss/hero-infra:0.0.1"
      }
    }
  }
}
  EOF
}
