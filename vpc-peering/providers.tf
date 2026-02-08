terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.31.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

provider "aws" {
    region = "us-west-2"
    alias = "peer"
  
}