resource "aws_iam_role" "instance_role" {
  name               = "batch-instance-${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.instance_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "instance_role" {
  role       = "${aws_iam_role.instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_role" {
  name = "batch-instance-${var.name}"
  role = "${aws_iam_role.instance_role.name}"
}

data "aws_iam_policy_document" "instance_role_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}
