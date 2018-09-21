resource "aws_security_group" "public_vpn_server" {
  name   = "public-vpn-server"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "public-vpn-server"
  }

  # ingress: wireguard, from anywhere
  ingress {
    from_port        = 51820
    to_port          = 51820
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "private_vpn_server" {
  name   = "private-vpn-server"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "private-vpn-server"
  }

  # egress: any ipv6, to the private subnet
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["${aws_subnet.private.ipv6_cidr_block}"]
  }
}

resource "aws_security_group" "vpn_target" {
  name   = "vpn-target"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "vpn-target"
  }

  # ingress: any ipv6, from the vpn
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["${var.vpn_ipv6_cidr_block}"]
  }
}
