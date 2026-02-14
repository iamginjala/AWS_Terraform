output "environment_name" {
    value = aws_elastic_beanstalk_environment.blue.cname
    description = "blue environment name"
}
output "blue_url" {
  value = aws_elastic_beanstalk_environment.blue.endpoint_url
  description = "blue environment url"
}
output "green_environment_name" {
    value = aws_elastic_beanstalk_environment.green.cname
    description = "green environment name"
}
output "green_url" {
  value = aws_elastic_beanstalk_environment.green.endpoint_url
  description = "green environment url"
}