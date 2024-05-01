# IAM roles and policies
resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]  # Add ec2.amazonaws.com here
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# ECR repository
resource "aws_ecr_repository" "my_repo" {
  name = "my-repo"
}

# EKS Cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["subnet-0e2ae21c000fd47bc", "subnet-05d19d961d0178c60"]  # Subnet IDs in your VPC
    security_group_ids = ["sg-0f96abeee5183e53c"]  # Security Group ID
  }
}

# Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn
  subnet_ids = ["subnet-0e2ae21c000fd47bc", "subnet-05d19d961d0178c60"]  # Subnet IDs in your VPC
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}