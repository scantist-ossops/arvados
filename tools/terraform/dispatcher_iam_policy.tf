resource "aws_iam_policy" "dispatcher_iam_policy" {
  name  = "${var.cluster}-dispatcher-iam-role-policy"
  description = "Policy to allow API to launch compute instances"
  policy = templatefile("${path.module}/dispatcher_iam_policy.json", {
    "cluster" = var.cluster
  })
}
