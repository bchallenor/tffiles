provider "aws" {}

resource "aws_security_group" "vpn" {
  name = "vpn"

  tags {
    Name = "vpn"
  }

  # ingress: wireguard, from anywhere
  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "intra" {
  name = "intra"

  tags {
    Name = "intra"
  }

  # ingress: anything, from this or vpn security group
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
    security_groups = ["${aws_security_group.vpn.id}"]
  }

  # egress: anything, to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
