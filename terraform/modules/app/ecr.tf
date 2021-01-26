resource "aws_ecr_repository" "figlet" {
  name                 = "figlet"
  image_tag_mutability = "IMMUTABLE"
}
