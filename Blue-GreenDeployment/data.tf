data "archive_file" "blue" {
  type        = "zip"
  source_dir = "./blue-app"
  output_path = "${path.module}/blue-app.zip"
}

data "archive_file" "green" {
  type        = "zip"
  source_dir = "./green-app"
  output_path = "${path.module}/green-app.zip"
}
