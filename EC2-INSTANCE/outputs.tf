
output "bucket_names_count" {
  description = "bucket names from count"
  value = [for i, item in aws_s3_bucket.test_bucket : "index ${i} is ${item.bucket}"]
  
}

output "bucket_ids_foreach" {
  description = "bucket ids from for_each"
  value = {for key,value in aws_s3_bucket.test_bucket2: key => value.bucket}
  
}
