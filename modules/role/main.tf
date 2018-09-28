resource "aws_iam_role" "role" {
  name               = "${var.name}"
  assume_role_policy = "${length(var.trusted_services) > 0 ? data.aws_iam_policy_document.mfa_and_services_trust_policy.json : data.aws_iam_policy_document.mfa_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "role" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
  count      = "${length(var.policy_arns)}"
}
