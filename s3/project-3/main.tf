# Configure the AWS Provider
resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
}

# Grant ECR permissions to the IAM user used by Terraform
resource "aws_iam_user_policy_attachment" "terrafrom_ecr_full_access" {
  user       = "terrafrom"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_s3_bucket" "puddle_app_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = false
  tags = {
    Name        = "zain-bucket-123"
    Environment = "Dev"
  }
}
#
resource "aws_s3_bucket_ownership_controls" "puddle_app_bucket_ownership_controls" {
  bucket = aws_s3_bucket.puddle_app_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "puddle_app_bucket_public_access_block" {
  bucket = aws_s3_bucket.puddle_app_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "puddle_app_bucket_versioning" {
  bucket = aws_s3_bucket.puddle_app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "puddle_app_bucket_sse" {
  bucket = aws_s3_bucket.puddle_app_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#now i well create dynamodb table and migration to enable terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


#end of terraform state locking
# -migrate -state=./terraform.tfstate
#terraform init -backend-config="dynamodb_table=terraform-locks" -backend-config="bucket=puddle-terraform-state-bucket" -backend-config="key=global/s3/terraform.tfstate" -backend-config="region=us-east-1"
