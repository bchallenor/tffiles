resource "aws_iam_policy" "write_policy" {
  name   = "git-${aws_codecommit_repository.repo.repository_name}-write"
  policy = data.aws_iam_policy_document.write_policy.json
}

data "aws_iam_policy_document" "write_policy" {
  statement {
    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
    ]

    resources = [
      aws_codecommit_repository.repo.arn,
    ]
  }
}

