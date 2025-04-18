# Output for the ID of the VPC created
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Output for the list of IDs of private subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# Output for the list of IDs of public subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# Output for the EKS cluster endpoint
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

# Output for the Security group ID attached to the EKS cluster
output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

# Output for the EKS cluster name
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

# Output for the Base64 encoded certificate data required to communicate with the cluster
output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

# Output for the DNS name of the load balancer for the SimpleTimeService
output "simpletimeservice_endpoint" {
  description = "The DNS name of the load balancer for the SimpleTimeService"
  value       = kubernetes_service.simpletimeservice.status.0.load_balancer.0.ingress.0.hostname
}