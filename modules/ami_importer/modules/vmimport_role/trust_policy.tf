data "aws_iam_policy_document" "trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vmie.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}
