terraform {
  backend "s3" {
    encrypt = true    
    bucket = "terraform-remote-state-jba2n"
    dynamodb_table = "terraform-state-table"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}