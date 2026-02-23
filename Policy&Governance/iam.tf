resource "aws_iam_policy" "mfa_policy" {
  name = "mfa-delete-policy"
  policy = jsonencode(
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Deny",
      "Action": [
        "s3:DeleteBucket",
        "s3:DeleteObject"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
  )
}

resource "aws_iam_policy" "s3_policy" {
  name = "s3-encryption-policy"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Deny",
      "Action": "s3:*",
      "Resource": "*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
})
}

resource "aws_iam_policy" "ec2_policy" {
  name = "ec2-runinstances-policy"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotLike": {
          "aws:RequestTag/Environment": "*"
        }
      }
    }
  ]
})
}

resource "aws_iam_user" "demo_user" {
  name = "test_policy_user"

}

resource "aws_iam_user_policy_attachment" "test_ec2_policy_attachment" {
  user = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}
resource "aws_iam_user_policy_attachment" "test_s3_policy_attachment" {
  user = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.s3_policy.arn
}
resource "aws_iam_user_policy_attachment" "test_mfa_policy_attachment" {
  user = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.mfa_policy.arn
}