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
  instance_profile_trusted_services = "${slice(list("ec2.amazonaws.com"), 0, var.create_instance_profile ? 1 : 0)}"
  trusted_services                  = "${distinct(concat(var.trusted_services, local.instance_profile_trusted_services))}"
}

data "aws_iam_policy_document" "mfa_and_services_trust_policy" {
  source_json = "${data.aws_iam_policy_document.mfa_trust_policy.json}"

  statement {
    principals {
      type        = "Service"
      identifiers = ["${local.trusted_services}"]
    }

    actions = ["sts:AssumeRole"]
  }
}

locals {
  trust_policy_json = "${length(local.trusted_services) > 0 ? data.aws_iam_policy_document.mfa_and_services_trust_policy.json : data.aws_iam_policy_document.mfa_trust_policy.json}"
}

data "aws_caller_identity" "self" {}
