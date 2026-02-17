output "source_bucket_name" {
  value = aws_s3_bucket.source.id
}
output "destination_bucket_name" {
  value = aws_s3_bucket.destination.bucket
}
output "lambda_function_name" {
  value = aws_lambda_function.image_processing.function_name
}