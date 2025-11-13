variable "vpc_id" {
  description = "VPC ID where security resources will be created"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0" # can restrict later to your IP
}

variable "tags" {
  description = "Common tags for security resources"
  type        = map(string)
  default     = {}
}