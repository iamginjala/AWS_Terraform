output "account_id" {
    value = data.aws_caller_identity.current
  
}
output "user_names" {
  value = [for user in aws_iam_user.test_users : user.name]
}

output "paswd" {
  value = [ for user in aws_iam_user_login_profile.test_login : user.password]
  sensitive = true
}