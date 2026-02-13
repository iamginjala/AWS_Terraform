resource "aws_vpc" "vpc_transistive" {
    cidr_block = var.cidr_block_transistive
    provider = aws.C
}

resource "aws_subnet" "tarns_subnet" {
    vpc_id = aws_vpc.vpc_transistive.id
    cidr_block = var.transistive_subnet
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.transistive.names[0]
    provider = aws.C
}

resource "aws_internet_gateway" "transistive_igw" {
  provider = aws.C
  vpc_id = aws_vpc.vpc_transistive.id

}