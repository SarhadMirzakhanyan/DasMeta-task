provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks_al2.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks_al2.cluster_certificate_authority_data)

  exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = [
        "eks", "get-token", 
        "--cluster-name", data.aws_eks_cluster.cluster.name, 
        "--role-arn", "arn:aws:iam::314647557426:user/terraform-user" #add role-arn
      ]
      command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_al2.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks_al2.cluster_certificate_authority_data)
  }
}

resource "aws_eks_addon" "adot" {
  depends_on = [ helm_release.cert_manager ]
  cluster_name                = module.eks_al2.cluster_name
  addon_name                  = "adot"
  addon_version               = "v0.94.1-eksbuild.1" 
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn = aws_iam_role.adot_role.arn
}

data "aws_eks_cluster" "cluster" {
  depends_on = [ module.eks_al2 ]
  name = module.eks_al2.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  depends_on = [ module.eks_al2 ]
  name = module.eks_al2.cluster_name
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.1"

  namespace  = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "global.leaderElection.namespace"
    value = "cert-manager"
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }
}