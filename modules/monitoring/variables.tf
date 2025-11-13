variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

variable "db_identifier" {
  description = "RDS identifier to monitor"
  type        = string
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
}

variable "tags" {
  description = "Tags for CloudWatch resources"
  type        = map(string)
  default     = {}
}
