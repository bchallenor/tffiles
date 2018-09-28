data "aws_iam_policy_document" "mfa_trust_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.self.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "mfa_and_services_trust_policy" {
  source_json = "${data.aws_iam_policy_document.mfa_trust_policy.json}"

  statement {
    principals {
      type        = "Service"
      identifiers = ["${var.trusted_services}"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_caller_identity" "self" {}
