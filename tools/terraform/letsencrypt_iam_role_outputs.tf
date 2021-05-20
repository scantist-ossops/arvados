output "letsencrypt_iam_policy_id" {
  value = aws_iam_policy.letsencrypt_iam_policy.id
}
output "letsencrypt_iam_policy_arn" {
  value = aws_iam_policy.letsencrypt_iam_policy.arn
}
output "letsencrypt_iam_role_arn" {
  value = aws_iam_role.letsencrypt_iam_role.arn
}
output "letsencrypt_iam_role_id" {
  value = aws_iam_role.letsencrypt_iam_role.id
}
