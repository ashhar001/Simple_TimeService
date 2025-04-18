module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Setting the cluster name and version
  cluster_name    = "Simple-App-Cluster"
  cluster_version = var.cluster_version

  # Disabling the creation of a CloudWatch log group
  create_cloudwatch_log_group = false

  # Enabling public access to the cluster endpoint
  cluster_endpoint_public_access = true

  # Granting admin permissions to the cluster creator
  enable_cluster_creator_admin_permissions = true

  # Disabling the creation of a KMS key and not specifying any encryption configuration
  create_kms_key            = false
  cluster_encryption_config = {}

  # Configuring cluster addons
  cluster_addons = {
    coredns                = {} # DNS service for the cluster
    eks-pod-identity-agent = {} # Agent for pod identity
    kube-proxy             = {} # Proxy for the cluster
  }

  # Associating the cluster with the VPC and subnets
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # Adding additional security group rules for node ports
  node_security_group_additional_rules = {
    nodeport_tcp = {
      description = "NodePort Rules"
      protocol    = "tcp"
      from_port   = 30000
      to_port     = 32767
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Configuring managed node groups
  eks_managed_node_groups = {
    eks_nodes = {
      desired_size = 1 # Desired number of nodes
      max_size     = 2 # Maximum number of nodes
      min_size     = 1 # Minimum number of nodes

      subnet_ids    = module.vpc.private_subnets # Subnets for the nodes
      instance_type = "t3.xlarge" # Instance type for the nodes
      key_name      = var.key_pair # Key pair for the nodes
    }
  }

  # Tags for the cluster
  tags = {
    Environment = "dev" # Environment tag
    Terraform   = "true" # Tag indicating Terraform management
  }
}