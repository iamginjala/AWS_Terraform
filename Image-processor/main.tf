resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_prefix = "${var.project_name}-${var.environment}"
  upload_bucket_name = "${local.bucket_prefix}-upload-${random_id.suffix.hex}"
  processed_bucket_name = "${local.bucket_prefix}-processed-${random_id.suffix.hex}"
  lambda_function_name  = "${var.project_name}-${var.environment}-processor"
}

resource "aws_s3_bucket" "source" {
    bucket = local.upload_bucket_name
    force_destroy = true
  
}

resource "aws_s3_bucket" "destination" {
    bucket = local.processed_bucket_name
    force_destroy = true
  
}

resource "aws_s3_bucket_public_access_block" "source_block" {
  bucket = aws_s3_bucket.source.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "destination_block" {
  bucket = aws_s3_bucket.destination.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "lambda_service" {
    name = "${local.bucket_prefix}-role"
    assume_role_policy = jsonencode(
        {
            Version = "2012-10-17"
            Statement = [
        {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        },
        ]   
        }
        
    )
  
}

resource "aws_iam_role_policy" "lambda_policy" {
    name = "${local.bucket_prefix}-policy"
    role = aws_iam_role.lambda_service.id
    policy = jsonencode({
         Version = "2012-10-17"
         Statement = [
        {
         Action = [
            "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.source.arn}/*"
      },
       {
         Action = [
            "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.destination.arn}/*"
      },
    ]
    })
  
}
resource "aws_iam_role_policy_attachment" "cw_logs" {
    role = aws_iam_role.lambda_service.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}
resource "aws_lambda_layer_version" "test_layer" {
    layer_name = "${local.bucket_prefix}-pillow-layer"
    filename = data.archive_file.layer.output_path
    compatible_runtimes = ["python3.12"]
    source_code_hash = data.archive_file.layer.output_base64sha256
}
resource "aws_lambda_function" "image_processing" {

  function_name = local.lambda_function_name
  role = aws_iam_role.lambda_service.arn
  runtime = "python3.12"
  handler = "handler.lambda_handler"
  filename = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  layers = [aws_lambda_layer_version.test_layer.arn]
  timeout = 30
  memory_size = 512
  environment {
    variables = {
      destination_bucket = aws_s3_bucket.destination.id
      LOG_LEVEL        = "INFO"
    }
    
  }

}
resource "aws_cloudwatch_log_group" "lambda_processor" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 7
}

resource "aws_lambda_permission" "s3_image_processing_permission" {
    statement_id = "image_${random_id.suffix.hex}"
    action = "lambda:InvokeFunction"
    function_name = local.lambda_function_name
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.source.arn
}

resource "aws_s3_bucket_notification" "upload_bucket_notification" {
 bucket =  aws_s3_bucket.source.id
 lambda_function {
   lambda_function_arn = aws_lambda_function.image_processing.arn
   events = ["s3:ObjectCreated:*"]
 }
 depends_on = [ aws_lambda_permission.s3_image_processing_permission ]
}