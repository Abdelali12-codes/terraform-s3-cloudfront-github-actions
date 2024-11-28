terraform {
  backend "s3" {
    bucket         = "terraform-state-shared-bucket" # Replace with your bucket name
    key            = "terraform-state/terraform.tfstate" # Customize this key structure if needed
    workspace_key_prefix = "states"
    region         = "us-east-1" # Replace with your region
    dynamodb_table = "arn:aws:dynamodb:us-east-1:080266302756:table/terraform-state-lock" # Replace with your DynamoDB table name
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-east-1"
}