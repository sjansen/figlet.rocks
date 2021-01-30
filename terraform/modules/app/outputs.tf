output "cloudFrontDistributionID" {
  value = aws_cloudfront_distribution.cdn.id
}

output "registry" {
  value = split("/", aws_ecr_repository.api.repository_url)[0]
}

output "repository-url" {
  value = aws_ecr_repository.api.repository_url
}

output "URL" {
  value = "s3://${aws_s3_bucket.media.bucket}?region=${aws_s3_bucket.media.region}"
}

