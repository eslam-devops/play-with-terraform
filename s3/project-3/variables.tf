# variable "ecr_name" {
#   description = "Name of the ECR repository"
#   type        = string
#   default     = "puddle-app-repo"
# }

# variable "s3_bucket_name" {
#   description = "Name of the s3 bucket"
#   type        = string
#   default     = "puddle-s3-media-nti"
# }
variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "puddle-app-repo"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for application assets"
  type        = string
  default     = "eslam-zain-bucket-123-20260118"
}
# variable "dynamodb_table_name" {
#   description = "Name of the DynamoDB table for Terraform state locking"
#   type        = string
#   default     = "terraform-locks"
# }
