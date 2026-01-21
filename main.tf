######################################
# EKS Cluster (Direct Resource)
######################################
resource "aws_eks_cluster" "this" {
  name     = "kilinov-eks-lab"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.34"

  vpc_config {
    subnet_ids = local.subnet_list
  }

  # ✅ REQUIRED FOR A LABS PORTAL
  upgrade_policy {
    support_type = "STANDARD"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_controller_policy
  ]
}

######################################
# EKS Managed Node Group
######################################

resource "aws_launch_template" "eks_nodes" {
  name_prefix = "eks-nodes-"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  key_name = "kilinov-keypair"
}

resource "aws_eks_node_group" "free_tier_nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "free-tier-nodes"
  node_role_arn  = aws_iam_role.eks_node_role.arn
  subnet_ids     = local.subnet_list

  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.latest_version
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}

#resource "aws_eks_addon" "ebs_csi" {
#  cluster_name = aws_eks_cluster.this.name
#  addon_name   = "aws-ebs-csi-driver"
#}