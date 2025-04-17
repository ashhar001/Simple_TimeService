terraform {
  required_version = ">= 1.11.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.90.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36.0"
    }
  }

  # backend "s3" {
  #   bucket         = "simple-app-service-terraform-state"
  #   key            = "terraform/env/dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "simple-app-terraform-locks"
  #   encrypt        = true
  # }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  # Credentials are provided via environment variables:
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
}