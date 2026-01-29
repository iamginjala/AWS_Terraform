output "sample_output" {
   description = "vpc id"
   value =   aws_vpc.main.id

}
output "s3_bucket_arn" {
  description = "s3 bucket arn"
  value = aws_s3_bucket.my_first_bucket.arn
  
}