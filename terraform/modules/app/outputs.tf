output "cloudFrontDistributionID" {
  value = aws_cloudfront_distribution.cdn.id
}

output "URL" {
  value = "s3://${aws_s3_bucket.media.bucket}?region=${aws_s3_bucket.media.region}"
}

