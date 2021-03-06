resource "aws_acm_certificate" "cert" {
  provider = aws.us-east-1

  domain_name       = var.dns_name
  validation_method = "DNS"

  tags = var.tags
}


resource "aws_acm_certificate_validation" "cert" {
  provider = aws.us-east-1

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}
