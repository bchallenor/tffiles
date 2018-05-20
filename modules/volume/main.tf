provider "aws" {}

resource "aws_ebs_volume" "volume" {
  tags {
    Name = "${var.name}"
  }

  availability_zone = "${var.availability_zone}"
  size              = "${var.size}"
  type              = "gp2"
  encrypted         = true
}
