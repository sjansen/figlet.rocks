resource "aws_cloudwatch_log_group" "api" {
  name = local.api_cloudwatch_prefix
  tags = var.tags

  retention_in_days = local.cloudwatch_retention
}
