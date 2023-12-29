## Overview

This directory includes two AWS CloudFormation templates. These templates are executed by GitHub Actions to set up the necessary infrastructure for hosting the React SPA application.

### [certificate.yml](certificate.yml)

This template is designed to create a new SSL certificate in AWS Certificate Manager, which will enable SSL connectivity for our website. 

`Before deploying this to your AWS account, you must have a pre-existing Route53 public hosted zone in place, which is required for validating the certificate.`

### [spa.yml](/spa.yml)

This template is designed to create the following resources in your AWS account:

1. Private S3 bucket
2. Cloudfront distibution pointing to your S3 bucket from above.
3. Origin access point to allow S3 bucket access to the CDN.
4. Route53 dns friendly name for CDN.

`Before deploying this to your AWS account, you must have a pre-existing Route53 public hosted zone in place, which is required for creating the Route53 dns CNAME.`
   
