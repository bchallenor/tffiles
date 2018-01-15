output "id" {
  value = "${aws_route53_zone.zone.zone_id}"
}

output "name" {
  value = "${aws_route53_zone.zone.name}"
}

output "bind_policy_arn" {
  value = "${aws_iam_policy.bind_policy.arn}"
}
