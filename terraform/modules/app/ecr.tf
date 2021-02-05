resource "aws_ecr_repository" "api" {
  name = local.ecr_repository_name
  tags = var.tags

  image_tag_mutability = "IMMUTABLE"
}
