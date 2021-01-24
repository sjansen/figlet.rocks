data "aws_iam_policy_document" "edge" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "edge" {
  name               = local.edge_function_name
  assume_role_policy = data.aws_iam_policy_document.edge.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "edge" {
  role       = aws_iam_role.edge.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
