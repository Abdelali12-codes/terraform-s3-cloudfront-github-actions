terraform {
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
  alias = "account1"
  profile = "abdelali"
}

provider "aws" {
  region = "us-east-1"
  alias = "account2"
  profile = "jadelmoula1"
}