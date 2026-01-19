terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region


  # (env vars / ~/.aws/credentials / IAM Role)
}


module "network" {
  source = "../modules/network"

  name     = "zain-vpc"
  vpc_cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  security_groups = {
    web = {
      description = "Web SG"

      ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]

      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "iam" {
  source = "../modules/iam_custom"

  roles = {
    ec2_role = {
      service = "ec2"
      enabled = true
      policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
      ]
    }
  }

  default_tags = {
    Project = "BlackCrow"
  }
}



module "instances" {
  source = "../modules/ec2_instance"

  name = "my-ec2-instance"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_ids[0]

  security_group_ids = [
    module.network.security_group_ids["web"]
  ]

  # ✅ IAM Role attached to EC2 Instance
  iam_instance_profile_name = module.iam.instance_profiles["ec2_role"].name

  instance_type = "t3.micro"
  key_pair_name = aws_key_pair.this.key_name

  user_data               = file("user_data.sh")
  disable_api_termination = true
  monitoring              = true
  root_volume_size        = 20
  root_volume_type        = "gp3"

  additional_tags = {
    Environment = "Production"
    Project     = "ESlam_zain"
  }
}
