module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.33.1"
  cluster_name                   = var.clusterName
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true
  subnet_ids                     = local.subnet_ids
  vpc_id                         = local.vpc_id

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    WG-1 = {
      min_size     = 1
      max_size     = 3
      desired_size = var.NodeCount

      instance_types = var.instance_types
      capacity_type  = "SPOT"
      labels = {
        Environment = "Lab"
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }

      update_config = {
        max_unavailable_percentage = 33
      }
      tags = local.tags
    }
  }

  tags = local.tags
}
