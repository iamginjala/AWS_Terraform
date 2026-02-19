resource "aws_s3_bucket" "test_static_website" {
    bucket = var.bucket_name
    force_destroy = true
    tags = {
      "env" = "test"
    }
  
}

resource "aws_s3_bucket_website_configuration" "test_website_config" {
    bucket = aws_s3_bucket.test_static_website.id
    index_document {
      suffix = "index.html"
    }
    error_document {
      key = "error.html"
    }
}


resource "aws_s3_object" "files" {
  for_each = toset(var.website_files)
  bucket = aws_s3_bucket.test_static_website.id
  key = each.value
  source = "./${each.value}"
  content_type = lookup(local.content_types,element(split(".",each.value),length(split(".",each.value))-1),"application/octet-stream")
}



resource "aws_cloudfront_origin_access_control" "test_oac" {
  name = "s3-origin-access"
  description = "origin access for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
  
}

resource "aws_cloudfront_distribution" "test_cloudfront" {
  origin {
    domain_name = aws_s3_bucket.test_static_website.bucket_regional_domain_name
    origin_id = var.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.test_oac.id
  }
  enabled = true
  default_root_object = var.default_root_object
  default_cache_behavior {
    allowed_methods = ["GET","HEAD"]
    cached_methods = ["GET","HEAD"]
    target_origin_id = var.origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }

    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  custom_error_response {
   error_code         = 403
   response_code      = 404
   response_page_path = "/error.html"
  }

  custom_error_response {
   error_code         = 404
   response_code      = 404
   response_page_path = "/error.html"
  }
  
}

data "aws_iam_policy_document" "test_iam_policy"{
  statement {
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]

    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.test_static_website.arn,"${aws_s3_bucket.test_static_website.arn}/*"]
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.test_cloudfront.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "test_policy" {
  bucket = aws_s3_bucket.test_static_website.id
  policy = data.aws_iam_policy_document.test_iam_policy.json
  
}
