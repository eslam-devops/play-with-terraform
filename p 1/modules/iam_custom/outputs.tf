output "role_arns" {
  value = {
    for k, v in aws_iam_role.this : k => v.arn
  }
}

output "instance_profiles" {
  value = aws_iam_instance_profile.ec2
}
