# # role for nodegroup

# resource "aws_iam_role" "nodes" {
#   name = "eks-node-group-nodes"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# # IAM policy attachment to nodegroup

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.nodes.name
# }


# # aws node group 

# resource "aws_eks_node_group" "private-nodes" {
#   cluster_name    = aws_eks_cluster.tech_challenge_cluster.name
#   node_group_name = "private-nodes"
#   node_role_arn   = aws_iam_role.nodes.arn

#   subnet_ids = [
#     "subnet-0c3275aa09915a25c",
#     "subnet-00971f2717645e100"
#   ]

#   capacity_type  = "ON_DEMAND"
#   instance_types = ["t2.small"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 10
#     min_size     = 0
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   labels = {
#     node = "kubenode02"
#   }


#   depends_on = [
#     aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }
