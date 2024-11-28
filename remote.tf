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


# aws s3 cross account access
data "aws_iam_policy_document" "s3_cross_account_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.github_oidc_role_account1.arn, 
          aws_iam_role.github_oidc_role_account2.arn]
    }

    actions = [
       "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:HeadBucket"
    ]

    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_cross_account_access" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.s3_cross_account_access.json
  provider =  aws.account1
}


# dynamodb cross account access
data "aws_iam_policy_document" "dynamodb_cross_account_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.github_oidc_role_account1.arn, 
          aws_iam_role.github_oidc_role_account2.arn]
    }

    actions = [
       "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:UpdateItem"
    ]

    resources = [
      aws_dynamodb_table.terraform_lock.arn
    ]
  }
}


resource "aws_dynamodb_resource_policy" "dynamodb_cross_account_access" {
  resource_arn = aws_dynamodb_table.terraform_lock.arn
  policy       = data.aws_iam_policy_document.dynamodb_cross_account_access.json
  provider = aws.account1
}

