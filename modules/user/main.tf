resource "aws_iam_user" "user" {
  name          = "${var.user}"
  force_destroy = "true"
}

resource "aws_iam_user_policy_attachment" "user" {
  user       = "${aws_iam_user.user.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
  count      = "${length(var.policy_arns)}"
}
