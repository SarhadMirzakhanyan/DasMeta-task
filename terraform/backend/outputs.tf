output "backet_name" {
  value = aws_s3_bucket.terraform_state_bucket.id

}

output "dynamo_table_name" {
  value = aws_dynamodb_table.terraform_statelock_table.id
}