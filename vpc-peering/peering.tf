resource "aws_vpc_peering_connection" "test_peer" {
    peer_vpc_id = aws_vpc.vpc_accepter.id
    vpc_id = aws_vpc.vpc_requester.id
    peer_region = "us-west-2"
    auto_accept = false
    tags = {
      Side = "Requester"
   }
}

resource "aws_vpc_peering_connection" "transistive_peer" {
    peer_vpc_id = aws_vpc.vpc_accepter.id
    vpc_id = aws_vpc.vpc_transistive.id
    peer_region = "us-west-2"
    auto_accept = false
    provider = aws.C
    tags = {
      Side = "transistive"
   }
}


resource "aws_vpc_peering_connection_accepter" "test_accept" {
  vpc_peering_connection_id = aws_vpc_peering_connection.test_peer.id
  auto_accept = true
  provider = aws.peer

  tags = {
    Side = "Accepter"
  }

}

resource "aws_vpc_peering_connection_accepter" "transistive_accept" {
  vpc_peering_connection_id = aws_vpc_peering_connection.transistive_peer.id
  auto_accept = true
  provider = aws.peer

  tags = {
    Side = "Accepter"
  }

}