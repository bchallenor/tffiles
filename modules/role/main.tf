resource "aws_iam_role" "role" {
  name               = var.name
  assume_role_policy = local.trust_policy_json
}

resource "aws_iam_role_policy" "role" {
  name   = var.name
  role   = aws_iam_role.role.name
  policy = var.policy_json
  count  = var.policy_json != "" ? 1 : 0
}

resource "aws_iam_role_policy_attachment" "role" {
  role       = aws_iam_role.role.name
  policy_arn = element(var.policy_arns, count.index)
  count      = length(var.policy_arns)
}

resource "aws_iam_instance_profile" "profile" {
  name  = var.name
  role  = aws_iam_role.role.name
  count = var.create_instance_profile ? 1 : 0
}

