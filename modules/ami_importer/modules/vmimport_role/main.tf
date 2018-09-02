resource "aws_iam_role" "role" {
  name               = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy.json}"
}

resource "aws_iam_role_policy" "role_policy" {
  name   = "${var.name}"
  role   = "${aws_iam_role.role.name}"
  policy = "${data.aws_iam_policy_document.role_policy.json}"
}
