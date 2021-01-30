locals {
  api_function_name   = var.dns_name
  api_gateway_name    = var.dns_name
  ecr_repository_name = var.dns_name
  edge_function_name  = "${var.dns_name}-rewrite"
}
