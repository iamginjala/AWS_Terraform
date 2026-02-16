variable "region" {
    default = "us-east-2"
    description = "default region for aws"
    type = string
}

variable "instance_type" {
    default = "t2.micro"
    description = "instance type for ec2 instances"
    type = string
}

variable "solution_stack" {
  default = "64bit Amazon Linux 2023 v4.9.3 running Python 3.14"
  description = "solution stack for elastic beanstalk"
  type = string
}

variable "blue_environment" {
  default = "Blue"
  description = "v1 for blue environment"
  type = string
}
variable "green_environment" {
    default = "Green"
    description = "v2 for green environment"
    type = string
}
variable "app_name" {
    default = "fruit_bowl"
    type = string
    description = "application name for bea stalk"
}