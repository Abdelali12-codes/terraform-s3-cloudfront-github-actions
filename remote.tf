resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-shared-bucket"
}


resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-lock"

  hash_key = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
  }
}

