provider "aws" {
  region = local.region
}

locals {
  region = var.region
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

#----------------------------------------------------------
#   Certificate 
#----------------------------------------------------------

module "aws_spa_infra" {
  source           = "../modules/cdn-s3"
  bucket_name      = var.bucket_name
  cert_arn         = var.cert_arn
  hosted_zone_name = var.hosted_zone_name
  tags             = local.default_tags
}
