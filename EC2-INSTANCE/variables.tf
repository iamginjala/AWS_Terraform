variable "environment" {
  type = string
  default = "dev"
  
}
variable "region" {
  type = string
  default = "us-east-2"
  
}
variable "instance_count" {
  type = number
  default = 1
  
}
variable "monitoring_enabled" {
  type = bool
  default = true
  
}
variable "associate_public_ip" {
  type = bool
  default = true
}

variable "cidr_blocks" {
  type = list(string)
  default = [ "10.0.0.0/16","10.0.1.0/24","10.0.2.0/24" ]
  
}
variable "tags" {
  
}