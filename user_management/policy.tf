resource "aws_iam_group_policy_attachment" "edu_policy" {
  group = aws_iam_group.edu_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  
}

resource "aws_iam_group_policy_attachment" "mng_policy" {
  group = aws_iam_group.mng_group.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_group_policy_attachment" "sales_policy" {
  group = aws_iam_group.sales_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  
}

resource "aws_iam_group_policy_attachment" "eng_power" {
  group = aws_iam_group.eng_group.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_policy" "mfa" {
    name = "DenyWithoutMFA"
    description = "Multi factor authentication policy"
    policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Deny",
			"Action": "*",
			"Resource": "*",
			"Condition": {
				"BoolIfExists": {
					"aws:MultiFactorAuthPresent": "false"
				}
			}
		}
	]
})
  
}


resource "aws_iam_user_policy_attachment" "test" {
    for_each = aws_iam_user.test_users
    user = each.value.name
    policy_arn = aws_iam_policy.mfa.arn
  
}