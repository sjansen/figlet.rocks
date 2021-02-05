variable "dns_name" {
  type = string
}

variable "dns_zone" {
  type = string
}

variable "staging_ecr_arn" {
  type        = string
  description = "e.g. arn:aws:ecr:us-east-1:123456789012:repository/preview.figlet.rocks"
}
