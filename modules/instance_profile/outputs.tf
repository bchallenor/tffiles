output "profile_name" {
  value = "${aws_iam_instance_profile.profile.name}"
}

output "role_arn" {
  value = "${aws_iam_role.role.arn}"
}
