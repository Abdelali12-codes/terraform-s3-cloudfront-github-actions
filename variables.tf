variable "aws_accounts" {
  description = "List of AWS account IDs where the IAM role should be created"
  type        = list(string)
  default     = ["080266302756", "043433929958"] # Replace with your account IDs
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = "Abdelali12-codes" # Replace with your GitHub organization name
}

variable "github_repo" {
  description = "GitHub repository"
  type        = string
  default     = "terraform-s3-cloudfront-github-actions" # Replace with your GitHub repository name
}