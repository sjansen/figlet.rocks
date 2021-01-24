module "app" {
  source = "../../modules/app"
  
  dns_name = "preview.figlet.rocks"
  dns_zone = "figlet.rocks"
  tags = {
    Environment = local.env
    Project     = local.proj
  }

  providers = {
    aws = aws
    aws.us-east-1 = aws.us-east-1
  }
}
