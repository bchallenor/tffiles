output "pull_policy_arn" {
  value = "${aws_iam_policy.pull_policy.arn}"
}

output "push_policy_arn" {
  value = "${aws_iam_policy.push_policy.arn}"
}
