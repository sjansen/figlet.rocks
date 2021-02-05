variable "dns_name" {
  type = string
}

variable "ecr_dst_arn" {
  type        = string
  description = "e.g. arn:aws:ecr:us-east-1:123456789012:repository/figlet.rocks"
}

variable "ecr_src_arn" {
  type        = string
  description = "e.g. arn:aws:ecr:us-east-1:123456789012:repository/preview.figlet.rocks"
}

variable "tags" {
  type = map(string)
}
