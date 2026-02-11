resource "aws_security_group" "requester_sg" {
    name = "default vpc security group"
    vpc_id = aws_vpc.vpc_requester.id

    ingress {
        description = "ssh form any where"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "icmp from accepter"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_accepter]
    }
    ingress {
        description = "all traffic from accepter vpc"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_accepter]
    }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "accepter_sg" {
    name = "accepter vpc security group"
    vpc_id = aws_vpc.vpc_accepter.id
    provider = aws.peer

    ingress {
        description = "ssh form any where"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "icmp from requester"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_requester]
    }
    ingress {
        description = "all traffic from requester vpc"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_requester]
    }
    ingress {
        description = "icmp from third vpc"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_transistive
        ]
    }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "trans_sg" {
    name = "transistive vpc security group"
    vpc_id = aws_vpc.vpc_transistive.id
    provider = aws.C

    ingress {
        description = "ssh form any where"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "icmp from requester"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_accepter]
    }
    ingress {
        description = "all traffic from requester vpc"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_accepter]
    }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}