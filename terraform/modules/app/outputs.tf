output "cloudFrontDistributionID" {
  value = aws_cloudfront_distribution.cdn.id
}

output "ecr_arn" {
  value = aws_ecr_repository.api.arn
}

output "function_arn" {
  value = aws_lambda_function.api.arn
}

output "function_name" {
  value = aws_lambda_function.api.function_name
}

output "registry" {
  value = split("/", aws_ecr_repository.api.repository_url)[0]
}

output "repository-arn" {
  value = aws_ecr_repository.api.arn
}

output "repository-url" {
  value = aws_ecr_repository.api.repository_url
}

output "URL" {
  value = "s3://${aws_s3_bucket.media.bucket}?region=${aws_s3_bucket.media.region}"
}

