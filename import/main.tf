import {
  to = aws_s3_bucket.my_bucket
  id = "my-unique-bucket-123-abc"
}

import {
  to = aws_s3_bucket_versioning.example
  id = "my-unique-bucket-123-abc"
}
import {
  to = aws_s3_bucket_server_side_encryption_configuration.example
  id = "my-unique-bucket-123-abc"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-123-abc"
}



resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = null
      sse_algorithm = "AES256"
    }
  }
}