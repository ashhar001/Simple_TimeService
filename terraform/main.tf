terraform {
  # Specifying the minimum required Terraform version
  required_version = ">= 1.11.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Specifying the version range for the AWS provider
      version = "~> 5.90.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      # Specifying the version range for the Kubernetes provider
      version = "~> 2.36.0"
    }
  }

  # Configuring the backend for state management
  backend "s3" {
    bucket         = "terraform-state-522814697098-us-east-2"
    key            = "simple-time-service/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks-522814697098"
    encrypt        = true
  }
}

# Configuring the AWS provider
provider "aws" {
  region = var.aws_region
  # AWS credentials are provided via environment variables:
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
}