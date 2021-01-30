data "archive_file" "edge" {
  type        = "zip"
  output_path = "${path.module}/cloudfront.zip"
  source {
    filename = "index.js"
    content  = file("${path.module}/cloudfront.js")
  }
}

resource "aws_lambda_function" "api" {
  image_uri    = "${aws_ecr_repository.api.repository_url}:latest"
  package_type = "Image"

  function_name = replace(local.api_function_name, "/[^-_a-zA-Z0-9]+/", "_")
  memory_size   = 128
  publish       = true
  role          = aws_iam_role.api.arn
  timeout       = 15

  tags = var.tags
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

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_apigatewayv2_api.api.execution_arn
}
