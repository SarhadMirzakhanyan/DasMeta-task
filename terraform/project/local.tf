data "aws_availability_zones" "available" {}

locals {
  region          = "us-east-1"
  vpc_name        = "meta-vpc"
  vpc_cidr        = "10.0.0.0/16"

  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Example = local.vpc_name
  }

  cluster_name = "dasmeta-cluster"
}