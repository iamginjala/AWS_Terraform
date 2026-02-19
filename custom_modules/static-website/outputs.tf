output "url" {
  value = aws_cloudfront_distribution.test_cloudfront.domain_name
  description = "the url to the static website"
}

output "bucket_name" {
  value = aws_s3_bucket.test_static_website.bucket
  description = "the name of s3 bucket"
}