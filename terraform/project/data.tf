data "aws_eks_cluster" "cluster" {
  depends_on = [module.eks_al2]
  name       = module.eks_al2.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  depends_on = [module.eks_al2]
  name       = module.eks_al2.cluster_name
}