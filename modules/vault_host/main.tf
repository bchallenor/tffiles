provider "aws" {
  region = "${var.region}"
}

provider "ct" {}

resource "aws_instance" "host" {
  tags {
    Name = "${var.name}"
  }

  availability_zone    = "${var.availability_zone}"
  instance_type        = "t2.nano"
  ami                  = "${data.aws_ami.coreos.image_id}"
  iam_instance_profile = "${var.profile_name}"
  user_data            = "${data.ct_config.config.rendered}"
}

data "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
}

data "template_file" "config" {
  template = "${file("${path.module}/config.yml")}"

  vars {
    ssh_public_key = "${var.ssh_public_key}"
    bucket_name    = "${var.bucket_name}"
    bucket_region  = "${data.aws_s3_bucket.bucket.region}"
  }
}

data "ct_config" "config" {
  content      = "${data.template_file.config.rendered}"
  platform     = "ec2"
  pretty_print = false
}

resource "aws_route53_record" "host" {
  zone_id = "${var.zone_id}"
  name    = "${var.name}.${var.zone_name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.host.public_ip}"]
}
