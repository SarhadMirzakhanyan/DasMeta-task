provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks_al2.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks_al2.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [
      "eks", "get-token",
      "region", "us-east-1",
      "--cluster-name", "dasmeta-cluster",
    ]
    command = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_al2.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks_al2.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = [
        "eks", "get-token",
        "region", "us-east-1",
        "--cluster-name", "dasmeta-cluster",
      ]
      command = "aws"
    }
  }
}

provider "kubectl" {
  host                   = module.eks_al2.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks_al2.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [
      "eks", "get-token",
      "region", "us-east-1",
      "--cluster-name", "dasmeta-cluster",
    ]
    command = "aws"
  }

}