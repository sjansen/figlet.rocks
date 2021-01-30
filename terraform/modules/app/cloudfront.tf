locals {
  s3_origin_id = "S3-${var.dns_name}"
}

resource "aws_cloudfront_distribution" "cdn" {
  provider = aws.us-east-1

  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  tags                = var.tags

  aliases = [
    var.dns_name
  ]

  custom_error_response {
    error_code            = 400
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 60
  }

  custom_error_response {
    error_code            = 500
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 502
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 503
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 504
    error_caching_min_ttl = 0
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    compress               = true
    default_ttl            = 900
    max_ttl                = 3600
    min_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = aws_lambda_function.edge.qualified_arn
    }
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_regional_domain_name
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "APIGW"

    compress               = true
    default_ttl            = 300
    max_ttl                = 3600
    min_ttl                = 0
    viewer_protocol_policy = "https-only"

    forwarded_values {
      headers      = ["Authorization"]
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  origin {
    domain_name = trimsuffix(trimprefix(aws_apigatewayv2_stage.api.invoke_url, "https://"), "/")
    origin_id   = "APIGW"
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.media.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cdn.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method  = "sni-only"
  }
}


resource "aws_cloudfront_origin_access_identity" "cdn" {
  provider = aws.us-east-1
  comment  = "OAI for ${var.dns_name}"
}
