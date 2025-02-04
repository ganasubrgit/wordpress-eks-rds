# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# IAM Role Policy Attachments for EKS Cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# IAM Role for EKS Managed Node Group
resource "aws_iam_role" "eks_node_role" {
  name               = "eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
}

data "aws_iam_policy_document" "node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role Policy Attachments for EKS Nodes
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# IAM Role for RDS Access (Optional if required by the application)
resource "aws_iam_role" "rds_access_role" {
  name               = "rds-access-role"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role_policy.json
}

data "aws_iam_policy_document" "rds_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

# IAM Policy for WordPress Pods to access RDS (Optional)
resource "aws_iam_policy" "wordpress_rds_access_policy" {
  name   = "wordpress-rds-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["rds:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach policy to IAM Role
resource "aws_iam_role_policy_attachment" "wordpress_rds_policy_attachment" {
  role       = aws_iam_role.rds_access_role.name
  policy_arn = aws_iam_policy.wordpress_rds_access_policy.arn
}
