output "ec2_cpu_alarms" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu
}

output "asg_cpu_alarm" {
  value = aws_cloudwatch_metric_alarm.asg_cpu
}

output "alb_requests_alarm" {
  value = aws_cloudwatch_metric_alarm.alb_requests
}
