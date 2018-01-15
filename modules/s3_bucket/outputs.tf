output "id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "read_policy_arn" {
  value = "${aws_iam_policy.read_policy.arn}"
}

output "write_policy_arn" {
  value = "${aws_iam_policy.write_policy.arn}"
}
