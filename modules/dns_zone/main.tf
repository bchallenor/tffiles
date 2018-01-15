provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "zone" {
  name = "${var.name}"
}

resource "aws_route53_record" "parent_ns" {
  count   = "${var.parent_id != "" ? 1 : 0}"
  zone_id = "${var.parent_id}"
  name    = "${aws_route53_zone.zone.name}"
  type    = "NS"
  ttl     = "3600"
  records = ["${aws_route53_zone.zone.name_servers}"]
}
