# Output the name of the Auto Scaling Group
output "asg_name" {
  value = aws_autoscaling_group.this.name
}


# Additional outputs for better clarity and utility
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
# Additional outputs for better clarity and utility
output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}
# Output the Auto Scaling Group ID
output "instance_ids" {
  # Return the Auto Scaling Group ID (instance IDs not available directly here)
  value = aws_autoscaling_group.this.id
}
# Output the list of instance IDs in the Auto Scaling Group
# output "instance_ids" {
#   description = "EC2 instance IDs in ASG"
#   value       = aws_autoscaling_group.this.instances
# Output the private IPs of instances in the Auto Scaling Group
# output "instance_private_ips" {
#   description = "Private IPs of EC2 instances in ASG"
#   value       = aws_autoscaling_group.this.instances[*].private_ip
# }
