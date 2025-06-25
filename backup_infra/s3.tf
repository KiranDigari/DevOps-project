resource "aws_s3_bucket" "logs_bucket" {
  bucket        = var.bucket_name
  force_destroy = true  # optional: helpful during testing

  tags = {
    Name  = "LogsBucket"
    Stage = var.stage
  }
}

resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "private"
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
      prefix = ""  # apply to all files
    }
  }
}
