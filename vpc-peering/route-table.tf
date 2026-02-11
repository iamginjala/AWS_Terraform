
resource "aws_route_table" "request_route" {
    vpc_id = aws_vpc.vpc_requester.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.request_igw.id
    }
    route {
        cidr_block = var.cidr_block_accepter
        vpc_peering_connection_id = aws_vpc_peering_connection.test_peer.id
    }
  
}
resource "aws_route_table" "accept_route" {
    vpc_id = aws_vpc.vpc_accepter.id
    provider = aws.peer

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.accept_igw.id
    }
    route {
        cidr_block = var.cidr_block_requester
        vpc_peering_connection_id = aws_vpc_peering_connection.test_peer.id
    }
    route {
        cidr_block = var.cidr_block_transistive
        vpc_peering_connection_id = aws_vpc_peering_connection.transistive_peer.id
    }


}

resource "aws_route_table" "transistive_route" {
  vpc_id =   aws_vpc.vpc_transistive.id
  provider = aws.C
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.transistive_igw.id
  }
  route {
        cidr_block = var.cidr_block_accepter
        vpc_peering_connection_id = aws_vpc_peering_connection.transistive_peer.id
    }
}
resource "aws_route_table_association" "accept_rta" {
    provider = aws.peer
    subnet_id = aws_subnet.accept_subnet.id
    route_table_id = aws_route_table.accept_route.id
  
}

resource "aws_route_table_association" "request_rta" {
  subnet_id = aws_subnet.request_subnet.id
  route_table_id = aws_route_table.request_route.id
}

resource "aws_route_table_association" "transistive_rta" {
    provider = aws.C
    subnet_id = aws_subnet.tarns_subnet.id
    route_table_id = aws_route_table.transistive_route.id
}