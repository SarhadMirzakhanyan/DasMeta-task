
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    spot_wg = {
      min_size = 2
      max_size = 3

      desired_size   = 2
      instance_types = ["t3.micro", "t3.nano"]
      capacity_type  = "SPOT"

      tags = {
        description = "cheap labor"
      }
    }
  }
}