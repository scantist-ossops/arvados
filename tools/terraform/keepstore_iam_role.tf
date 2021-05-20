# Assume role policy for the instance
resource "aws_iam_role" "keepstore_iam_assume_role" {
  count = var.keepstore_count
  name = "${var.cluster}-keepstore-${format("%02d", count.index)}-iam-role"

  assume_role_policy = file("${path.module}/iam_policy_assume_role.json")
}

# IAM policy to access the bucket
resource "aws_iam_policy" "keepstore_iam_policy" {
  count = var.keepstore_count
  name  = "${var.cluster}-keepstore-${format("%02d", count.index)}-iam-role-policy"
  description = "Policy to allow writing to the S3 bucket ${var.cluster}-nyw5e-${format("%016d", count.index)}-volume-policy"
  policy = templatefile("${path.module}/keepstore_iam_policy.json", {
    "bucket_arn" = aws_s3_bucket.keepstore.*.arn[count.index]
  })
}

# Associate the assume role policy to the access bucket policy
resource "aws_iam_role_policy_attachment" "keepstore_policies_attachment" {
  count = var.keepstore_count
  role       = aws_iam_role.keepstore_iam_assume_role.*.name[count.index]
  policy_arn = aws_iam_policy.keepstore_iam_policy.*.arn[count.index]
}

# Add the assume-role to the instance profile
resource "aws_iam_instance_profile" "keepstore_instance_profile" {
  count = var.keepstore_count
  name  = "keepstore-${format("%02d", count.index)}_instance_profile"
  role = "${var.cluster}-keepstore-${format("%02d", count.index)}-iam-role"
}
