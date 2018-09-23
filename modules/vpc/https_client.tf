resource "aws_security_group" "https_client" {
  name   = "https-client"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "https-client"
  }

  # egress: https, to anywhere
  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
