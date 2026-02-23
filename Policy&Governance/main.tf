resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.project_name}-config-bucket-hg2308"
  force_destroy = true
}
resource "aws_s3_bucket_versioning" "config_bucket_version" {
      bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
}
resource "aws_s3_bucket_server_side_encryption_configuration" "config_sse" {
  bucket = aws_s3_bucket.config_bucket.id
  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "config_block" {
  bucket = aws_s3_bucket.config_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}