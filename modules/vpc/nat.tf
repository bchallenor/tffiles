resource "aws_security_group" "public_nat_server" {
  name   = "public-nat-server"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "public-nat-server"
  }

  # egress: any ipv4, to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_nat_server" {
  name   = "private-nat-server"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "private-nat-server"
  }

  # ingress: any ipv4, from the private subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_subnet.private.cidr_block}"]
  }
}

resource "aws_network_interface" "private_nat_server" {
  subnet_id = "${aws_subnet.private.id}"

  security_groups   = ["${aws_security_group.private_nat_server.id}"]
  source_dest_check = false

  tags {
    Name = "${var.name}-private-nat-server"
  }
}
