data "archive_file" "edge" {
  type        = "zip"
  output_path = "${path.module}/cloudfront.zip"
  source {
    filename = "index.js"
    content  = file("${path.module}/cloudfront.js")
  }
}

resource "aws_lambda_function" "edge" {
  provider = aws.us-east-1

  filename         = data.archive_file.edge.output_path
  source_code_hash = data.archive_file.edge.output_base64sha256

  function_name = replace(local.edge_function_name, "/[^-_a-zA-Z0-9]+/", "_")
  handler       = "index.handler"
  memory_size   = 128
  publish       = true
  role          = aws_iam_role.edge.arn
  runtime       = "nodejs12.x"
  timeout       = 3

  tags = var.tags
}
