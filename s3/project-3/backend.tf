terraform {
  backend "s3" {
    bucket         = "eslam-zain-bucket-123-20260118"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# terraform init -migrate-state
# terraform init -reconfigure
# terraform apply -auto-approve
# terraform init -backend-config="bucket=eslam-zain-bucket-123-20260118" -backend-config="key=global/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="dynamodb_table=terraform-locks" -backend-config="encrypt=true"
# terraform init -backend-config="path/to/backend.config"

