variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "type" {
  description = "The type of security group (public or private)"
  type        = string
}

variable "ssh_cidr" {
  description = "The CIDR block allowed to access the public instances via SSH"
  type        = string
  default     = "0.0.0.0/0"
}
