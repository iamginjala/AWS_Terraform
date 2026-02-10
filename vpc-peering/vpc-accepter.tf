resource "aws_vpc" "vpc_accepter" {
    cidr_block = var.cidr_block_accepter
    provider = aws.peer
}

resource "aws_subnet" "accept_subnet" {
    vpc_id = aws_vpc.vpc_accepter.id
    cidr_block = var.accepter_subnet
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.accepter.names[0]
    provider = aws.peer
}

resource "aws_internet_gateway" "accept_igw" {
  provider = aws.peer
  vpc_id = aws_vpc.vpc_accepter.id

}