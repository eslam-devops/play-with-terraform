output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.network.public_subnet_ids
}

output "security_group_ids" {
  description = "Security Group IDs"
  value       = module.network.security_group_ids
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = module.instances.instance_id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = module.instances.public_ip
}

output "ec2_private_ip" {
  description = "EC2 Private IP"
  value       = module.instances.private_ip
}
output "iam_role_arns" {
  value = module.iam.role_arns
}

output "iam_instance_profile_name" {
  value = module.iam.instance_profiles["ec2_role"].name
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = "ssh -i ~/.ssh/eslam_main_key ec2-user@${module.instances.public_ip}"
}
output "web-site" {
  description = "my web site"
  value       = "http://${module.instances.public_ip}"
}



