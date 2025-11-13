output "sns_topic_arn" {
  description = "SNS topic for alert notifications"
  value       = aws_sns_topic.alerts.arn
}
