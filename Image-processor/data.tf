data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "./lambda"
  output_path = "${path.module}/lambda.zip"
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir = "./layer"
  output_path = "${path.module}/layer.zip"
}