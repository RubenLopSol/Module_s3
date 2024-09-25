resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = var.logging_bucket_name
  target_prefix = "${var.bucket_name}/logs/"
  
  depends_on = [aws_s3_bucket.secure_bucket]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# S3 bucket policy for TLS and encryption
resource "aws_s3_bucket_policy" "secure_bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = var.custom_bucket_policy != null ? var.custom_bucket_policy : jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:*",
        Effect    = "Deny",
        Principal = "*",
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.secure_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.secure_bucket.bucket}/*"
        ],
        Condition = {
          Bool: {
            "aws:SecureTransport": "false"
          }
        }
      },
      {
        Action    = "s3:PutObject",
        Effect    = "Deny",
        Principal = "*",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.secure_bucket.bucket}/*",
        Condition = {
          StringNotEquals: {
            "s3:x-amz-server-side-encryption": "AES256"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    id     = "expire_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = "Enabled"

      expiration {
        days = rule.value.expiration.days
      }
      
      filter {
        prefix = rule.value.prefix
      }
    }
  }
}
