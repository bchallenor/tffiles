data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:SendMessage",
    ]

    resources = [
      aws_sqs_queue.task.arn,
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      local.bucket_arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:prefix"

      values = [
        "ami/",
      ]
    }
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${local.bucket_arn}/ami/*.img",
    ]
  }

  statement {
    actions = [
      "ec2:ImportSnapshot",
      "ec2:DescribeImportSnapshotTasks",
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  # For safety, restrict deletion to snapshots without a parent volume.
  # This makes it less likely that we will accidentally delete a backup.
  statement {
    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "ec2:ParentVolume"

      values = [
        "arn:aws:ec2:*:*:volume/vol-ffffffff",
      ]
    }
  }

  statement {
    actions = [
      "ec2:DescribeImages",
      "ec2:RegisterImage",
      "ec2:DeregisterImage",
    ]

    resources = ["*"]
  }
}

