resource "aws_ecr_repository" "api" {
  name                 = local.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  tags = var.tags
}
