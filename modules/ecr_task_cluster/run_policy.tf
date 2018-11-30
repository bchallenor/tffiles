data "aws_iam_policy_document" "run_policy" {
  statement {
    actions = [
      "ecs:RunTask",
    ]

    resources = [
      "${aws_ecs_task_definition.task.*.arn}",
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    resources = [
      "${var.exec_role_arn}",
      "${var.task_role_arn}",
    ]
  }
}
