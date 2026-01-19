# minitoring EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  for_each            = toset(var.ec2_instance_ids)
  alarm_name          = "${each.value}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Monitor EC2 CPU utilization"
  alarm_actions       = [] # you can add actions like SNS topics
  dimensions = {
    InstanceId = each.value
  }
}

# minitoring ASG CPU Utilization
resource "aws_cloudwatch_metric_alarm" "asg_cpu" {
  alarm_name          = "${var.asg_name}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Monitor ASG CPU utilization"
  alarm_actions       = [] #you can add actions like scaling policies
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# minitoring ALB Request Count
resource "aws_cloudwatch_metric_alarm" "alb_requests" {
  alarm_name          = "${var.alb_arn}-request-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 120
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "Monitor ALB request count"
  alarm_actions       = [] # you can add actions like scaling policies
  dimensions = {
    LoadBalancer = var.alb_arn
  }
}
