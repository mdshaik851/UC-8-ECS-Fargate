resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
 alarm_name = "HighCPUUtilization"
 comparison_operator = "GreaterThanThreshold"
 evaluation_periods = "2"
 metric_name = "CPUUtilization"
 namespace = "AWS/ECS"
 period = "60"
 statistic = "Average"
 threshold = "80"
 alarm_description = "This metric monitors high CPU usage"
 dimensions = {
 ClusterName = var.cluster_name
 }
}
