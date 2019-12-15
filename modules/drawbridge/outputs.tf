output "policy_arn" {
  value = aws_iam_policy.policy.arn
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

