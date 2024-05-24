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

provider "aws" {
  region = var.AWS_REGION
}

resource "aws_codecommit_repository" "terraform_infrastructure" {
  repository_name = "terraform-infrastructure"
  description     = "Repository tracking the Terraform Infrastructure for the project"
}

resource "aws_iam_role" "codebuild" {
  name = "codebuild-tf-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_role_attachment" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "terraform-build" {
  name = "terraform-build"
  description = "CodeBuild project to apply the Terraform Infrastructure"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  service_role = aws_iam_role.codebuild.arn

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.terraform_infrastructure.clone_url_http
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  source_version = "master"
}

resource "aws_iam_role" "codepipeline" {
  name = "codepipeline-tf-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_attachment" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_s3_bucket" "terraform_artifacts" {
  bucket_prefix = "terraform-artifacts"
}

resource "aws_codepipeline" "terraform-pipeline" {
  name     = "terraform-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.terraform_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.terraform_infrastructure.repository_name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform-build.name
      }
    }
  }
}
