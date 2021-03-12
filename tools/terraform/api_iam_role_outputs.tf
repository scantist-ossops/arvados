output "dispatcher_iam_policy_id" {
  value = aws_iam_policy.dispatcher_iam_policy.id
}
output "dispatcher_iam_policy_arn" {
  value = aws_iam_policy.dispatcher_iam_policy.arn
}
output "letsencrypt_route53_iam_policy_id" {
  value = aws_iam_policy.letsencrypt_route53_iam_policy.id
}
output "letsencrypt_route53_iam_policy_arn" {
  value = aws_iam_policy.letsencrypt_route53_iam_policy.arn
}
output "api_iam_role_arn" {
  value = aws_iam_role.api_iam_role.arn
}
output "api_iam_role_id" {
  value = aws_iam_role.api_iam_role.id
}
