
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = local.common_tags
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "bucket-with-tf-2308"

  tags = local.common_tags
}


