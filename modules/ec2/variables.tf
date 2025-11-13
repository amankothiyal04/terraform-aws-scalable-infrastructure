variable "vpc_id" {
  description = "VPC ID to launch EC2 instances in"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group ID for EC2"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM Role ARN for EC2"
  type        = string
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "tags" {
  description = "Common tags for EC2"
  type        = map(string)
  default     = {}
}
