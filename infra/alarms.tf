locals {
  alarm_actions      = [data.aws_ssm_parameter.alarms_topic_arn.insecure_value]
  service_missing_as = var.desired_count > 0 ? "breaching" : "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "app_cpu" {
  alarm_name          = "${local.app_name}-cpu"
  alarm_description   = "ADS-B task CPU above 85 %, or no data while the service should run"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  dimensions          = { ClusterName = local.cluster_name, ServiceName = aws_ecs_service.app.name }
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 85
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = local.service_missing_as
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "app_memory" {
  alarm_name          = "${local.app_name}-memory"
  alarm_description   = "ADS-B task memory above 85 %, or no data while the service should run"
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  dimensions          = { ClusterName = local.cluster_name, ServiceName = aws_ecs_service.app.name }
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 85
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = local.service_missing_as
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
}
