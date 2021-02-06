locals {
  api_cloudwatch_prefix = "/aws/lambda/${local.api_function_name}"
  api_function_name     = replace(var.dns_name, "/[^-_a-zA-Z0-9]+/", "_")
  api_gateway_name      = var.dns_name
  api_iam_role_name     = var.dns_name

  cloudwatch_retention = 90

  ecr_repository_name = var.dns_name

  edge_function_name = "${var.dns_name}-rewrite"
}
