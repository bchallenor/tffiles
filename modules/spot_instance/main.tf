provider "aws" {}

resource "aws_spot_instance_request" "instance" {
  ami           = "${data.aws_ami.ami.id}"
  instance_type = "${var.instance_type}"

  spot_price                      = "${var.spot_price}"
  spot_type                       = "one-time"
  instance_interruption_behaviour = "terminate"
  wait_for_fulfillment            = true

  availability_zone      = "${var.availability_zone}"
  vpc_security_group_ids = ["${var.security_group_id}"]

  root_block_device {
    volume_size           = "${var.root_volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "standard"
  }

  timeouts {
    create = "5m"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.name}-*"]
  }
}

resource "aws_volume_attachment" "persistent" {
  device_name = "/dev/xvdp"
  volume_id   = "${var.persistent_volume_id}"
  instance_id = "${aws_spot_instance_request.instance.spot_instance_id}"
}

resource "aws_route53_record" "cname" {
  zone_id = "${var.zone_id}"
  name    = "${var.name}.${var.zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_spot_instance_request.instance.public_dns}"]
}
