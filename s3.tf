resource "aws_s3_bucket" "web_bucket" {
  bucket = "devopszain-123456" # لازم اسم unique
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
