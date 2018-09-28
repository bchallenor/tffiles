output "name" {
  value = "${aws_iam_role.role.name}"
}

output "arn" {
  value = "${aws_iam_role.role.arn}"
}

output "assume_policy_arn" {
  value = "${aws_iam_policy.assume_policy.arn}"
}
