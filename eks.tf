# IAM role for eks

resource "aws_iam_role" "tech_challenge_cluster_role" {
  name = "tech-challenge-eks-cluster"
  tags = {
    tag-key = "tech-challenge-eks-cluster"
  }

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# eks policy attachment

resource "aws_iam_role_policy_attachment" "tech_challenge_cluster_policy" {
  role       = aws_iam_role.tech_challenge_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# bare minimum requirement of eks

resource "aws_eks_cluster" "tech_challenge_cluster" {
  name     = "tech_challenge"
  role_arn = aws_iam_role.tech_challenge_cluster_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-0c3275aa09915a25c",
      "subnet-00971f2717645e100",
      "subnet-07a371f0c2f8dd740",
      "subnet-04b66e840b6cbaac3"
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.tech_challenge_cluster_policy]
}