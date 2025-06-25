resource "aws_s3_bucket" "logs_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  object_ownership = "BucketOwnerEnforced"  # Disable ACLs explicitly

  tags = {
    Name  = "LogsBucket"
    Stage = var.stage
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id     = "delete-logs-after-7-days"
    status = "Enabled"

    expiration {
      days = 7
    }

    filter {
      prefix = ""  # Apply to all files
    }
  }
}

