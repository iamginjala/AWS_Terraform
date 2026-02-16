resource "aws_s3_bucket" "application" {
   bucket = "application-bucket-hg-23121998"

  tags = {
    Name        = "My bucket"
    Environment = "Blue"
  }
}
resource "aws_s3_object" "blue_object" {
     bucket = aws_s3_bucket.application.bucket
     key    = "prod/blue.zip"
     source = data.archive_file.blue.output_path
  
}
resource "aws_s3_object" "green_object" {
     bucket = aws_s3_bucket.application.bucket
     key    = "staging/green.zip"
     source = data.archive_file.green.output_path
  
}
resource "aws_iam_role" "beanstalk_service" {
    name = "service_role"
    assume_role_policy = jsonencode(
        {
          Version = "2012-10-17"
          Statement = [
        {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        },
        ]   
        }
    )
  
}
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.beanstalk_service.name
}
resource "aws_iam_role_policy_attachment" "policy_attachment" {
    role = aws_iam_role.beanstalk_service.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
    
}
resource "aws_elastic_beanstalk_application" "tf_ebs" {
  name        = var.app_name
  description = "present version for the application"

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
}
resource "aws_elastic_beanstalk_application_version" "blue_ebs_av" {
    application = aws_elastic_beanstalk_application.tf_ebs.name
    bucket = aws_s3_bucket.application.id
    key = aws_s3_object.blue_object.key
    name = "my-blue-application-version"
  
}
resource "aws_elastic_beanstalk_application_version" "green_ebs_av" {
    application = aws_elastic_beanstalk_application.tf_ebs.name
    bucket = aws_s3_bucket.application.id
    key = aws_s3_object.green_object.key
    name = "my-green-application-version"
  
}
resource "aws_elastic_beanstalk_environment" "blue" {
  application = aws_elastic_beanstalk_application.tf_ebs.name
  solution_stack_name = var.solution_stack
  name = var.blue_environment
  version_label = aws_elastic_beanstalk_application_version.blue_ebs_av.name
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = aws_iam_instance_profile.test_profile.name
  }
  setting {
    name = "InstanceType"
    namespace ="aws:autoscaling:launchconfiguration"
    value = var.instance_type
  }
  setting {
    name = "EnvironmentType"
    namespace = "aws:elasticbeanstalk:environment"
    value = "SingleInstance"
  }
}
resource "aws_elastic_beanstalk_environment" "green" {
  application = aws_elastic_beanstalk_application.tf_ebs.name
  solution_stack_name = var.solution_stack
  name = var.green_environment
  version_label = aws_elastic_beanstalk_application_version.green_ebs_av.name
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = aws_iam_instance_profile.test_profile.name
  }
  setting {
    name = "InstanceType"
    namespace ="aws:autoscaling:launchconfiguration"
    value = var.instance_type
  }
  setting {
    name = "EnvironmentType"
    namespace = "aws:elasticbeanstalk:environment"
    value = "SingleInstance"
  }
  depends_on = [aws_elastic_beanstalk_environment.blue]

}

