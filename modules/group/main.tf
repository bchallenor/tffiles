resource "aws_iam_group" "group" {
  name = "${var.group}"
}

resource "aws_iam_group_policy_attachment" "group" {
  group      = "${aws_iam_group.group.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
  count      = "${length(var.policy_arns)}"
}

resource "aws_iam_group_membership" "group" {
  name  = "${var.group}"
  group = "${aws_iam_group.group.name}"
  users = ["${var.users}"]
}
