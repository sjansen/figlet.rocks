module "app" {
  source = "../../modules/app"

  dns_name = var.dns_name
  dns_zone = var.dns_zone
  tags     = local.tags

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}

module "utils" {
  source = "../../modules/utils"

  dns_name      = var.dns_name
  function_arn  = module.app.function_arn
  function_name = module.app.function_name
  ecr_dst_arn   = module.app.ecr_arn
  ecr_src_arn   = var.staging_ecr_arn
  tags          = local.tags

  providers = {
    aws = aws
  }
}
