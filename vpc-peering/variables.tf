variable "cidr_block_requester" {
    type = string
    default = "10.0.0.0/16"
    description = "cidr block range for vpc requester"
  
}

variable "cidr_block_accepter" {
    type = string
    default = "11.0.0.0/16"
    description = "cidr block range for vpc accepter"
}

variable "cidr_block_transistive" {
    type = string
    default = "12.0.0.0/16"
    description = "cidr block range for vpc accepter transistive"
}

variable "requester_subnet" {
  type = string
  default = "10.0.1.0/24"
  description = "cidr block range for requester subnet"
}

variable "accepter_subnet" {
  type = string
  default = "11.0.1.0/24"
  description = "cidr block range for accepter subnet"
}
variable "transistive_subnet" {
  type = string
  default = "12.0.1.0/24"
  description = "cidr block range for transistive subnet"
}

variable "primary_key_name" {
  description = "Name of the SSH key pair for request VPC instance (us-east-1)"
  type        = string
  default     = "vpc-peering-demo"
}

variable "secondary_key_name" {
  description = "Name of the SSH key pair for accept VPC instance (us-west-2)"
  type        = string
  default     = "vpc-peering-demo-west"
}

