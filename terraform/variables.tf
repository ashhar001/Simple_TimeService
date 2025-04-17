variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

# AWS credentials are provided via environment variables:
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "Simple-App-Cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "SimpletTimeService-eks-vpc"
}

variable "key_pair" {
  description = "The key pair name for EC2 instances in the EKS node group"
  type        = string
  default     = "eks-cluster-key"
}

variable "app_image" {
  description = "Container image for the Node.js application"
  type        = string
  default     = "ashhar001/simple-time-service:v1.0.0"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}