variable "vpc_id" {
  description = "ID of the VPC to create security groups in"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  type        = string
}

variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}
