module "eks_al2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    worker_ng = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]

      min_size = 2
      max_size = 2
      desired_size = 2

      capacity_type = "SPOT"
    }
  }

  tags = local.tags
}


resource "helm_release" "nginx" {
  name       = "nginx-web-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "15.0.1"

  namespace = "default"

  values = [
    file("nginx-values.yaml")
  ]
}
