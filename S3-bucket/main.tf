terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "bucket-with-tf-2308"

  tags = {
    Name        = "My bucket1.0"
    Environment = "Dev"
  }
}