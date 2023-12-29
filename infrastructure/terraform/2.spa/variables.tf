variable "application" {
  description = "Application name to use"
  type        = string
}

variable "bucket_name" {
  type = string
}

variable "environment" {
  description = "Environment name to use"
  type        = string
}

variable "hosted_zone_name" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "region" {
  description = "AWS region to use"
  type        = string
}

variable "tags" {
  type = map(any)
}