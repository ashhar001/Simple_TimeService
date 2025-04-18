# Variable for specifying the AWS region where resources will be deployed
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2" # Default region set to us-east-2
}

# Note: AWS credentials are provided via environment variables:
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY

# Variable for specifying the name of the EKS cluster
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "Simple-App-Cluster" # Default cluster name set to Simple-App-Cluster
}

# Variable for specifying the Kubernetes version to use for the EKS cluster
variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32" # Default Kubernetes version set to 1.32
}

# Variable for specifying the name for the VPC
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "SimpletTimeService-eks-VPC" # Default VPC name set to SimpletTimeService-eks-VPC
}

# Variable for specifying the key pair name for EC2 instances in the EKS node group
variable "key_pair" {
  description = "The key pair name for EC2 instances in the EKS node group"
  type        = string
  default     = "eks-cluster-key" # Default key pair name set to eks-cluster-key
}

# Variable for specifying the container image for the Node.js application
variable "app_image" {
  description = "Container image for the Node.js application"
  type        = string
  default     = "ashhar001/simple-time-service:v1.0.0" # Default app image set to ashhar001/simple-time-service:v1.0.0
}

# Variable for specifying the deployment environment (e.g., dev, staging, prod)
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev" # Default environment set to dev
}