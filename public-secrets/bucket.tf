resource "aws_s3_bucket" "bucket" {
  bucket = var.aws_s3_bucket_name
  acl    = var.aws_s3_bucket_acl

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id  = aws_kms_key.key.arn
        sse_algorithm      = "aws:kms"
      }
    }
  }

  tags = {
      Name = var.aws_s3_bucket_name
  }
}

