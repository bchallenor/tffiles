data "aws_iam_policy_document" "run_policy" {
  statement {
    actions = [
      "ecs:DescribeTaskDefinition",
    ]

    resources = ["*"]
  }

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
      "ecs:DescribeTasks",
    ]

    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"

      values = [
        "${aws_ecs_cluster.default.arn}",
      ]
    }
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

  statement {
    actions = [
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.default.arn}",
    ]
  }
}
