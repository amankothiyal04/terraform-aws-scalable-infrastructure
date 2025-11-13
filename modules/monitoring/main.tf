# SNS  for notifications
resource "aws_sns_topic" "alerts" {
  name = "infra-alerts-topic"
  tags = merge(var.tags, { Name = "infra-alerts" })
}

# Subscribe our email to SNS
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# EC2 CPU Alarm
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "EC2-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when EC2 CPU > 80%"
  dimensions = {
    InstanceId = var.instance_id
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  tags          = merge(var.tags, { Name = "EC2-CPU-Alarm" })
}

# RDS Storage Alarm
resource "aws_cloudwatch_metric_alarm" "rds_storage_high" {
  alarm_name          = "RDS-Storage-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 10000000000 # 10 GB
  alarm_description   = "Triggered when RDS free storage < 10 GB"
  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  tags          = merge(var.tags, { Name = "RDS-Storage-Alarm" })
}
