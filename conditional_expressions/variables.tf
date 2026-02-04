variable "region" {
    description = "default region for aws"
    type = string
    default = "us-east-2"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

variable "ingress_rule" {
    type = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
      description = string
      }))
      default = [
        {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Http"
        },
        {
            from_port = 443
            to_port = 443
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Https"
        }
      ] 
}