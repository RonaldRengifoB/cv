resource "aws_dynamodb_table" "dynamodb_tfstate_lock" {
  name           = "tfstate-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

}
