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
