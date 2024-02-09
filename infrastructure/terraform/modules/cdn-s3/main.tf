data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone_name
}

resource "aws_s3_bucket" "cdn_bucket" {
  bucket        = join("", [var.bucket_name, ".", var.hosted_zone_name])
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.cdn_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.bucket_name}-oac"
  description                       = "CDN Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cloud_front" {
  depends_on = [aws_s3_bucket.cdn_bucket, aws_cloudfront_origin_access_control.oac]

  comment = "Cloudfront Distribution pointing to S3 bucket"

  aliases = [join("", [var.bucket_name, ".", var.hosted_zone_name])]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    compress         = true
    target_origin_id = "${var.bucket_name}-origin"
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
      headers = ["Origin"]
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  price_class         = "PriceClass_100"

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  origin {
    domain_name              = aws_s3_bucket.cdn_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "${var.bucket_name}-origin"
  }

  viewer_certificate {
    acm_certificate_arn      = var.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  tags = var.tags
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [
    aws_cloudfront_distribution.cloud_front
  ]
  bucket = join("", [var.bucket_name, ".", var.hosted_zone_name])

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cdn_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.cloud_front.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_route53_record" "cdn_route" {
  name    = join("", [var.bucket_name, ".", var.hosted_zone_name])
  type    = "A"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.cloud_front.domain_name
    zone_id                = aws_cloudfront_distribution.cloud_front.hosted_zone_id
    evaluate_target_health = false
  }
  depends_on = [
    aws_cloudfront_distribution.cloud_front
  ]
}
