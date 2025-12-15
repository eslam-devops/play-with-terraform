provider "aws" {
  region = "us-east-1"
}
# S3 Bucket الأساسي
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-simple-bucket-eslam-123456"
}
# Server Side Encryption (التشفير التلقائي)
resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


