output "high_cpu_alarm_name" {
  description = "Name of the high CPU alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization_high.alarm_name
}

output "high_cpu_alarm_arn" {
  description = "ARN of the high CPU alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization_high.arn
}