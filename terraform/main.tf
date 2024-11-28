# S3 Bucket in Account 3
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.bucket_name
  acl    = "public-read"
  block_public_policy = false

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })

  tags = {
    Environment = "production"
    Account     = "Account3"
    Project     = "Website Hosting"
  }
}