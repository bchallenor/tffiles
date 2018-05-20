resource "aws_iam_policy" "policy" {
  name   = "terraform"
  policy = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "codecommit:GetRepository",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:ListTags",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "cloudwatch:DescribeAlarms",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:Describe*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:GetGroup",
      "iam:GetInstanceProfile",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetSSHPublicKey",
      "iam:GetUser",
      "iam:ListAccountAliases",
      "iam:ListAttachedGroupPolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListAttachedUserPolicies",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "s3:GetAccelerateConfiguration",
      "s3:GetBucket*",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "sns:GetTopicAttributes",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "sts:DecodeAuthorizationMessage",
    ]

    resources = [
      "*",
    ]
  }
}
