# CloudWatch Log Group for ECS Service
resource "aws_cloudwatch_log_group" "ecs_agaile" {
  name              = "/ecs/agaile-service"
  retention_in_days = 1  # Set to 1 day retention

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-ecs-agaile-logs"
    Purpose = "monitoring"
    Service = "agaile"
  })
}

# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "${var.name_prefix}-agaile-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors ECS CPU utilization"
  alarm_actions      = [aws_sns_topic.ecs_alerts.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-agaile-cpu-alarm"
    Purpose = "monitoring"
    Service = "agaile"
  })
}

# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_memory" {
  alarm_name          = "${var.name_prefix}-agaile-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors ECS memory utilization"
  alarm_actions      = [aws_sns_topic.ecs_alerts.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-agaile-memory-alarm"
    Purpose = "monitoring"
    Service = "agaile"
  })
}

# SNS Topic for Alerts
resource "aws_sns_topic" "ecs_alerts" {
  name = "${var.name_prefix}-ecs-alerts"

  tags = merge(var.common_tags, {
    Name    = "${var.name_prefix}-ecs-alerts"
    Purpose = "monitoring"
    Service = "agaile"
  })
} 