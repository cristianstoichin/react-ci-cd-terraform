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

module "aws_certificate" {
  source = "../modules/certificate"

  sub_domain       = var.sub_domain
  hosted_zone_name = var.hosted_zone_name
  tags             = local.default_tags
}
