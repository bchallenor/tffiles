resource "aws_iam_policy" "read_policy" {
  name   = "git-${aws_codecommit_repository.repo.repository_name}-read"
  policy = data.aws_iam_policy_document.read_policy.json
}

data "aws_iam_policy_document" "read_policy" {
  statement {
    actions = [
      "codecommit:GitPull",
    ]

    resources = [
      aws_codecommit_repository.repo.arn,
    ]
  }
}

