data "aws_iam_policy_document" "AssumeRole-codebuild" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.codebuild.arn,
      "${aws_cloudwatch_log_group.codebuild.arn}:log-stream:*",
    ]
  }
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = [var.ecr_src_arn]
  }
  statement {
    actions = [
      "ecr:ListTagsForResource",
      "ecr:UploadLayerPart",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:TagResource",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = [var.ecr_dst_arn]
  }
}

resource "aws_iam_role" "codebuild" {
  name = local.codebuild_role
  tags = var.tags

  assume_role_policy = data.aws_iam_policy_document.AssumeRole-codebuild.json
  path               = "/service-role/"
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "all-the-things"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}
