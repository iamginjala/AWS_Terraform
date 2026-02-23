resource "aws_iam_role" "config_role" {
  name = "config_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "config.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "rpa" {
  role = aws_iam_role.config_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.config_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_config_configuration_recorder" "cr" {
  role_arn = aws_iam_role.config_role.arn
  recording_group {
    all_supported = true
  } 
}
resource "aws_config_delivery_channel" "cdc" {
  s3_bucket_name = aws_s3_bucket.config_bucket.id
}

resource "aws_config_configuration_recorder_status" "crs" {
    name =  aws_config_configuration_recorder.cr.name
    is_enabled = true
    depends_on = [ aws_config_delivery_channel.cdc ] 
}

resource "aws_config_config_rule" "s3_public_write" {
  name = "s3_public_write_prohibited"

  source {
    owner = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = [ aws_config_configuration_recorder.cr ]
}

resource "aws_config_config_rule" "s3_encryption" {
  name = "s3-encryption-enabled"
  source {
    owner = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
  depends_on = [ aws_config_configuration_recorder.cr ]
}

resource "aws_config_config_rule" "s3_public_read" {
  name = "s3-public-read-prohibited"
  source {
    owner = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  depends_on = [ aws_config_configuration_recorder.cr ]
}
resource "aws_config_config_rule" "ebs_volume" {
  name = "ebs-volumes-encrypted"
  source {
    owner = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }
  depends_on = [ aws_config_configuration_recorder.cr ]
}
resource "aws_config_config_rule" "iam_password" {
  name = "iam_password_policy"
  source {
    owner = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
  depends_on = [ aws_config_configuration_recorder.cr ]
}
resource "aws_config_config_rule" "root_mfa" {
  name = "root-mfa-enabled"
  source {
    owner = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
  depends_on = [ aws_config_configuration_recorder.cr ]
}
resource "aws_config_config_rule" "required_tags" {
  name = "required-tags"
  source {
    owner = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }
  input_parameters = jsonencode({
    tag1Key = "Environment"
    tag2Key = "Owner"
  })
  depends_on = [ aws_config_configuration_recorder.cr ]
}
