data "aws_iam_policy_document" "ecr-api" {
  statement {
    sid = "LambdaECRImageRetrievalPolicy"
    actions = [
      "ecr:BatchGetImage",
      "ecr:DeleteRepositoryPolicy",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:SetRepositoryPolicy",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_ecr_repository" "api" {
  name = local.ecr_repository_name
  tags = var.tags

  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "api" {
  repository = aws_ecr_repository.api.name
  policy     = data.aws_iam_policy_document.ecr-api.json
}
