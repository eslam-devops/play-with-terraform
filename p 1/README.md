# Terraform AWS Network Module

## Overview
This project provides a reusable and production-ready **Terraform Network Module** for AWS.
It is designed following DevOps best practices with a clear separation of concerns and clean module structure.

The module is responsible for:
- Creating a VPC
- Creating Public Subnets across multiple Availability Zones
- Attaching an Internet Gateway
- Configuring a public Route Table
- Managing dynamic Security Groups and rules

---

## Resources Created
- aws_vpc
- aws_internet_gateway
- aws_subnet (Public)
- aws_route_table
- aws_route_table_association
- aws_security_group
- aws_security_group_rule (Ingress / Egress)

---

## Module Structure

```
modules/network/
├── main.tf
├── variables.tf
├── locals.tf
└── outputs.tf
```

---

## Input Variables

### Required Variables

| Name | Type | Description |
|-----|------|-------------|
| name | string | Resource name prefix |
| vpc_cidr | string | CIDR block for the VPC |
| azs | list(string) | Availability Zones |
| public_subnets | list(string) | Public subnet CIDR blocks |
| security_groups | map(object) | Security Group definitions |

---

## security_groups Structure

```
security_groups = {
  web = {
    description = "Web SG"

    ingress = [
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
```

Supported ingress types:
- CIDR-based ingress rules
- Security Group to Security Group rules using `sg_refs`

---

## Outputs

| Name | Description |
|-----|-------------|
| vpc_id | VPC ID |
| public_subnet_ids | List of public subnet IDs |
| security_group_ids | Map of security group IDs |

---

## Example Usage

```
module "network" {
  source = "../../modules/network"

  name     = "blackcrow"
  vpc_cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  security_groups = {
    web = {
      description = "Web SG"

      ingress = [
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
```

---

## Design Principles
- Separation of concerns (network only)
- Dynamic and reusable configuration
- Multi-AZ ready
- Production-friendly defaults

---

## Security Notes
Opening SSH (22) to 0.0.0.0/0 is acceptable for labs and testing.
For production, restrict access:

```
cidr_blocks = ["YOUR_IP/32"]
```

---

## Author
Eslam (zain)
DevOps Engineer – AWS & Terraform
