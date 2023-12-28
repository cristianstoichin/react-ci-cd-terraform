variable "bucket_name" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "tags" {
  type = map(any)
}