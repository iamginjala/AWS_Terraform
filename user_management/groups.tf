resource "aws_iam_group" "edu_group" {
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "mng_group" {
  name = "Managers"
  path = "/groups/"
}

resource "aws_iam_group" "sales_group" {
  name = "Sales"
  path = "/groups/"
}

resource "aws_iam_group" "eng_group" {
  name = "Engineering"
  path = "/groups/"
}

resource "aws_iam_group_membership" "edu_mem" {
  name = "education-group-membership"
  group = aws_iam_group.edu_group.name
  users = [ for user in aws_iam_user.test_users : user.name if user.tags["Department"] == "Education"] 
}

resource "aws_iam_group_membership" "mng_mem" {
  name = "senior-level-group-membership"
  group = aws_iam_group.mng_group.name
  users = [ for user in aws_iam_user.test_users : user.name if strcontains(user.tags["JobTitle"],"Manager") || strcontains(user.tags["JobTitle"],"CEO")] 
}

resource "aws_iam_group_membership" "sales_mem" {
  name = "sales-group-membership"
  group = aws_iam_group.sales_group.name
  users = [ for user in aws_iam_user.test_users : user.name if user.tags["Department"] == "Sales"] 
}

resource "aws_iam_group_membership" "eng_mem" {
  name = "engineering-group-membership"
  group = aws_iam_group.eng_group.name
  users = [ for user in aws_iam_user.test_users : user.name if user.tags["Department"] == "Engineering"] 
}
