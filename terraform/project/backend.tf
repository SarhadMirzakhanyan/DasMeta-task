terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-remote-state-jba2n"
    dynamodb_table = "terraform-state-table"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
  }
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}