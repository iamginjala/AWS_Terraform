terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "deom-for-tfstate-files-0128"
    encrypt = true
    key = "dev/terraform.tfstate"
    region = "us-east-2"
    use_lockfile = true
  }
}
variable "my_tag" {
  default = "dev"
  type = string
  
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = var.my_tag
  }
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "bucket-with-tf-2308"

  tags = {
    Environment  =  var.my_tag
  }
}

output "sample_output" {
   description = "vpc id"
   value =   aws_vpc.main.id

}
output "s3_bucket_arn" {
  description = "s3 bucket arn"
  value = aws_s3_bucket.my_first_bucket.arn
  
}
