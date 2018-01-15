data "aws_iam_policy_document" "bind_policy" {
  statement {
    actions = [
      "route53:ListHostedZones",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.zone.zone_id}",
    ]
  }
}

resource "aws_iam_policy" "bind_policy" {
  name   = "zone-${substr(aws_route53_zone.zone.name, 0, length(aws_route53_zone.zone.name) - 1)}-bind"
  policy = "${data.aws_iam_policy_document.bind_policy.json}"
}
