
resource "random_string" "bucket_suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-remote-state-${random_string.bucket_suffix.result}"

}

resource "aws_dynamodb_table" "terraform_statelock_table" {
  name         = "terraform-state-table"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

}