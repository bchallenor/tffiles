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

locals {
  instance_profile_trusted_services = slice(
    ["ec2.amazonaws.com"],
    0,
    var.create_instance_profile ? 1 : 0,
  )
  trusted_services = distinct(
    concat(
      var.trusted_services,
      local.instance_profile_trusted_services,
    ),
  )
}

data "aws_iam_policy_document" "mfa_and_services_trust_policy" {
  source_json = data.aws_iam_policy_document.mfa_trust_policy.json

  statement {
    principals {
      type = "Service"
      # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
      # force an interpolation expression to be interpreted as a list by wrapping it
      # in an extra set of list brackets. That form was supported for compatibility in
      # v0.11, but is no longer supported in Terraform v0.12.
      #
      # If the expression in the following list itself returns a list, remove the
      # brackets to avoid interpretation as a list of lists. If the expression
      # returns a single list item then leave it as-is and remove this TODO comment.
      identifiers = [local.trusted_services]
    }

    actions = ["sts:AssumeRole"]
  }
}

locals {
  trust_policy_json = length(local.trusted_services) > 0 ? data.aws_iam_policy_document.mfa_and_services_trust_policy.json : data.aws_iam_policy_document.mfa_trust_policy.json
}

data "aws_caller_identity" "self" {
}

