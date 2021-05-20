resource "aws_iam_role" "letsencrypt_iam_role" {
    name = "${var.cluster}-letsencrypt-iam-role"

    assume_role_policy = templatefile("${path.module}/iam_policy_assume_role.json", {})
}

resource "aws_iam_role_policy_attachment" "letsencrypt_policies_attachment" {
    role       = aws_iam_role.letsencrypt_iam_role.name
    policy_arn = aws_iam_policy.letsencrypt_iam_policy.arn
}

resource "aws_iam_policy" "letsencrypt_iam_policy" {
  name  = "${var.cluster}-letsencrypt-iam-role-policy"
  description = "Policy to allow LetsEncrypt to modify route53 DNS records"
  policy = templatefile("${path.module}/letsencrypt_iam_policy.json", {
    "cluster" = var.cluster
    "zone_id" = aws_route53_zone.public.id
  })
}

resource "aws_iam_instance_profile" "letsencrypt_instance_profile" {
  name  = "letsencrypt_instance_profile"
  role = "${var.cluster}-letsencrypt-iam-role"
}
