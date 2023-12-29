## Overview

This directory includes the terraform templates for the SSL certificate and the SPA infrastructure. These templates are executed by GitHub Actions to set up the necessary infrastructure for hosting the React SPA application.

### [SSL Cert Template](https://github.com/cristianstoichin/react-ci-cd-terraform/tree/main/infrastructure/terraform/1.cert)

This template is designed to create a new SSL certificate in AWS Certificate Manager, which will enable SSL connectivity for our website. 

The template is using the [dev.tfvars](https://github.com/cristianstoichin/react-ci-cd-terraform/blob/main/infrastructure/terraform/1.cert/variables/dev.tfvars) as entry parameters. You will need to change these for your needs. 

`Before deploying this to your AWS account, you must have a pre-existing Route53 public hosted zone in place, which is required for validating the certificate.`

The templates are using this [configuration file](https://github.com/cristianstoichin/react-ci-cd-terraform/blob/main/infrastructure/terraform/1.cert/config/backend-dev.hcl) to tell Terraform where the state files are stored. In this case, we use an S3 terraform backend. 

`Before deploying this to your AWS account, you must have a pre-existing S3 bucket created in your AWS account and change` [this value](https://github.com/cristianstoichin/react-ci-cd-terraform/blob/main/infrastructure/terraform/1.cert/config/backend-dev.hcl#L1C3-L1C50) `to your bucket's name.`

### [SPA Template](https://github.com/cristianstoichin/react-ci-cd-terraform/tree/main/infrastructure/terraform/2.spa)

This template is designed to create the following resources in your AWS account:

1. Private S3 bucket
2. Cloudfront distibution pointing to your S3 bucket from above.
3. Origin access point to allow S3 bucket access to the CDN.
4. Route53 dns friendly name for CDN.

The template is using the [dev.tfvars](https://github.com/cristianstoichin/react-ci-cd-terraform/blob/main/infrastructure/terraform/2.spa/variables/dev.tfvars) as entry parameters. You will need to change these for your needs. 

`Before deploying this to your AWS account, you must have a pre-existing Route53 public hosted zone in place, which is required for validating the certificate.`

The templates are using this [configuration file](https://github.com/cristianstoichin/react-ci-cd-terraform/blob/main/infrastructure/terraform/2.spa/config/backend-dev.hcl) to tell Terraform where the state files are stored. In this case, we use an S3 terraform backend. 

`Before deploying this to your AWS account, you must have a pre-existing S3 bucket created in your AWS account and change` [this value](https://github.com/cristianstoichin/react-ci-cd-terraform/blob/main/infrastructure/terraform/2.spa/config/backend-dev.hcl#L1) `to your bucket's name.`
