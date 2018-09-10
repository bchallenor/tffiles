resource "aws_iam_role" "service_role" {
  name               = "batch-service-${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.service_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "service_role" {
  role       = "${aws_iam_role.service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

data "aws_iam_policy_document" "service_role_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}
