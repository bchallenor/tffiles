resource "aws_security_group" "http_client" {
  name   = "http-client"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "http-client"
  }

  # egress: http, to anywhere
  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
