provider "aws" {}

resource "aws_iam_policy" "policy" {
  name   = "param-store-scope-${var.name}"
  policy = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DeleteParameter",
    ]

    resources = [
      "arn:aws:ssm:*:${data.aws_caller_identity.self.account_id}:${var.name}/*",
    ]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    resources = ["${var.key_arn}"]

    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:PARAMETER_ARN"

      values = [
        "arn:aws:ssm:*:${data.aws_caller_identity.self.account_id}:${var.name}/*",
      ]
    }
  }
}

data "aws_caller_identity" "self" {}
