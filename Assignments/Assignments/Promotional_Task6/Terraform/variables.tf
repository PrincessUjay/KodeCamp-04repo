variable "aws_region" {
  description = "AWS region where the resources will be deployed"
  type        = string
  default     = "eu-west-1"
}

variable "key_name" {
  description = "Name of the SSH key pair for accessing EC2 instances"
  type        = string
}
