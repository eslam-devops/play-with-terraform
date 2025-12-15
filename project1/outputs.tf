output "ec2_public_ip" {
  value = aws_instance.web_server.public_ip
}
# إخراج اسم الـ Bucket
output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
