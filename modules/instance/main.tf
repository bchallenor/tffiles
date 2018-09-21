provider "aws" {}

resource "aws_instance" "instance" {
  ami           = "${data.aws_ami.ami.id}"
  instance_type = "${var.instance_type}"

  availability_zone      = "${var.availability_zone}"
  vpc_security_group_ids = ["${var.security_group_ids}"]

  iam_instance_profile = "${var.instance_profile_name}"

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

  tags {
    Name = "${var.name}"
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
  device_name = "/dev/xvd${substr("pqr", count.index, 1)}"
  volume_id   = "${element(var.persistent_volume_ids, count.index)}"
  instance_id = "${aws_instance.instance.id}"
  count       = "${length(var.persistent_volume_ids)}"
}

# Use CNAME for public as it can be resolved inside the VPC to an internal IP
resource "aws_route53_record" "cname" {
  zone_id = "${var.zone_id}"
  name    = "${var.name}.${var.zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_instance.instance.public_dns}"]
}
