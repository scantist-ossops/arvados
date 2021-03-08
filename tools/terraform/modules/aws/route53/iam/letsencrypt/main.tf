# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
resource "aws_iam_user" "letsencrypt" {
  name = "${var.cluster_name}-letsencrypt"
  path = "/"
}

resource "aws_iam_access_key" "letsencrypt" {
  user = aws_iam_user.letsencrypt.name
}

resource "aws_iam_user_policy" "iam_letsencrypt_route53_policy" {
  name = "${var.cluster_name}_letsencrypt_route53_policy"
  user = aws_iam_user.letsencrypt.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "${var.cluster_name}_letsencrypt_route53_policy",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "arn:aws:route53:::hostedzone/${var.zone_id}"
            ]
        }
    ]
}
EOF
}
