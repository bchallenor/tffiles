output "clone_url_ssh" {
  value = "${aws_codecommit_repository.repo.clone_url_ssh}"
}

output "clone_url_http" {
  value = "${aws_codecommit_repository.repo.clone_url_http}"
}

output "read_policy_arn" {
  value = "${aws_iam_policy.read_policy.arn}"
}

output "write_policy_arn" {
  value = "${aws_iam_policy.write_policy.arn}"
}
