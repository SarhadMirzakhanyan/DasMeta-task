resource "aws_security_group" "eks_sg" {
    name        = "dasmeta eks cluster"
    description = "Allow traffic"
    vpc_id      = module.vpc.default_vpc_id

    ingress {
      description      = "World"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "EKS alb sg",
      "kubernetes.io/cluster/${local.cluster_name}": "owned"
    }
  }

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
  cluster_additional_security_group_ids = [aws_security_group.eks_sg.id]

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
    file("templates/nginx-values.yaml")
  ]
}
