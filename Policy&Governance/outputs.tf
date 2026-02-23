output "bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}
output "iam_user_name" {
  value = aws_iam_user.demo_user.name
}
output "config_recorder_name" {
  value = aws_config_configuration_recorder.cr.name
}

output "mfa_policy" {
  value = aws_iam_policy.mfa_policy.arn
}
output "ec2_policy" {
  value = aws_iam_policy.ec2_policy.arn
}
output "s3_policy" {
  value = aws_iam_policy.s3_policy.arn
}