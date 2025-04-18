# Configuring the Kubernetes provider with EKS cluster details
provider "kubernetes" {
  # Using the EKS cluster endpoint from the module output
  host = module.eks.cluster_endpoint
  # Decoding the base64 encoded cluster CA certificate from the module output
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  # Configuring the exec plugin for authentication
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# Creating a local variable to store the subnet IDs as a comma-separated string
locals {
  subnet_ids_string = join(",", module.vpc.public_subnets)
}

# Defining a Kubernetes deployment for the SimpleTimeService application
resource "kubernetes_deployment" "simpletimeservice" {
  # Ensuring the deployment is created after the EKS cluster is ready
  depends_on = [module.eks]

  metadata {
    name = "simpletimeservice"
    labels = {
      app     = "simpletimeservice"
      version = "v1.0.0"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "simpletimeservice"
      }
    }

    template {
      metadata {
        labels = {
          app     = "simpletimeservice"
          version = "v1.0.0"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path"   = "/health"
          "prometheus.io/port"   = "3000"
        }
      }

      spec {
        node_selector = {
          "kubernetes.io/arch" = "amd64"
          "kubernetes.io/os"   = "linux"
        }

        security_context {
          run_as_user  = 1001
          run_as_group = 1001
          fs_group     = 1001
        }

        container {
          name  = "simpletimeservice"
          image = var.app_image

          env {
            name  = "PLATFORM"
            value = "linux/amd64"
          }

          port {
            container_port = 3000
            name           = "http"
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
            run_as_user                = 1001
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 2
            failure_threshold     = 3
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 15
            period_seconds        = 20
            timeout_seconds       = 2
            failure_threshold     = 3
          }

          resources {
            requests = {
              memory = "128Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "256Mi"
              cpu    = "200m"
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Defining a Kubernetes service for the SimpleTimeService application
resource "kubernetes_service" "simpletimeservice" {
  # Ensuring the service is created after the deployment is ready
  depends_on = [kubernetes_deployment.simpletimeservice]

  metadata {
    name = "simpletimeservice"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                     = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"                   = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"           = "*"
      "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags" = "Environment=${var.environment}"
      "service.beta.kubernetes.io/aws-load-balancer-subnets"                  = local.subnet_ids_string
      "service.beta.kubernetes.io/aws-load-balancer-internal"                 = "false"
    }
  }

  spec {
    type                    = "LoadBalancer"
    external_traffic_policy = "Local"

    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "simpletimeservice"
    }
  }
}
