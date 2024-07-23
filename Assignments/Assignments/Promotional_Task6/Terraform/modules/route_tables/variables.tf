variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to associate with the route table"
  type        = list(string)
}

variable "is_public" {
  description = "Boolean to determine if the route table is public"
  type        = bool
}

variable "igw_id" {
  description = "The ID of the Internet Gateway"
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  type        = string
  default     = null
}