resource "aws_iam_role" "dispatcher_iam_role" {
    name = "${var.cluster}-dispatcher-iam-role"

    assume_role_policy = templatefile("${path.module}/iam_policy_assume_role.json", {})
}

resource "aws_iam_role_policy_attachment" "dispatcher_policies_attachment" {
    role       = aws_iam_role.dispatcher_iam_role.name
    policy_arn = aws_iam_policy.dispatcher_iam_policy.arn
}

resource "aws_iam_policy" "dispatcher_iam_policy" {
  name  = "${var.cluster}-dispatcher-iam-role-policy"
  description = "Policy to allow API to launch compute instances"
  policy = templatefile("${path.module}/dispatcher_iam_policy.json", {
    "cluster" = var.cluster
  })
}

resource "aws_iam_instance_profile" "dispatcher_instance_profile" {
  name  = "dispatcher_instance_profile"
  role = "${var.cluster}-dispatcher-iam-role"
}
