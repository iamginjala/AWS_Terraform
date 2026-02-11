resource "aws_instance" "requester_ec2" {
  ami = data.aws_ami.requester_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.request_subnet.id
  vpc_security_group_ids = [aws_security_group.requester_sg.id]
  key_name = var.primary_key_name
  user_data = local.primary_user_data

  depends_on = [aws_vpc_peering_connection_accepter.test_accept]

}

resource "aws_instance" "accepter_ec2" {
    ami = data.aws_ami.accepter_ami.id
    subnet_id = aws_subnet.accept_subnet.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.accepter_sg.id]
    key_name = var.secondary_key_name
    provider = aws.peer
    user_data = local.secondary_user_data

    depends_on = [aws_vpc_peering_connection_accepter.test_accept]


}
resource "aws_instance" "trans_ec2" {
    ami = data.aws_ami.transistive_ami.id
    subnet_id = aws_subnet.tarns_subnet.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.trans_sg.id]
    provider = aws.C
    user_data = local.tertiary_user_data

    depends_on = [aws_vpc_peering_connection_accepter.transistive_accept]


}
