resource "aws_iam_role" "role" {
  name               = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "role" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
  count      = "${length(var.policy_arns)}"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.name}"
  role = "${aws_iam_role.role.name}"
}
