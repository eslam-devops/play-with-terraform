variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id" { type = string }
variable "ec2_sg_id" { type = string }

variable "instance_type" {
  default = "t3.micro"
}

variable "key_pair_name" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "desired_capacity" { default = 1 }
variable "min_size" { default = 1 }
variable "max_size" { default = 3 }