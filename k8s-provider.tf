data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}

# Provedor Kubernetes para o Terraform
provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Criar a política IAM para o Load Balancer Controller
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"

  policy = file("iam_policy.json") # Baixe o arquivo JSON da política e salve no diretório do projeto
}

# Criar um Role IAM para a ServiceAccount do Load Balancer Controller
resource "aws_iam_role" "alb_controller_role" {
  name = "alb-controller-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Anexar a política ao Role
resource "aws_iam_role_policy_attachment" "alb_controller_policy_attach" {
  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = aws_iam_role.alb_controller_role.name
}

# Associar a Role à ServiceAccount
resource "kubernetes_service_account" "alb_controller_service_account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}

# Instalar o AWS Load Balancer Controller via Helm
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = aws_vpc.main.id
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller_service_account.metadata[0].name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}

# Definir o Ingress no Kubernetes
resource "kubernetes_ingress_v1" "example_ingress" {
  metadata {
    name      = "tech-challenge-ingress"
    namespace = "default"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/target-type"  = "ip"
      "alb.ingress.kubernetes.io/group.name"   = "my-api-ingress-group"
    }
  }

  spec {
    rule {
      host = "pagamento.tech-challenge.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "pagamentos-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "usuario-cliente.tech-challenge.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "usuario-cliente-app-cluster-ip-svc"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}