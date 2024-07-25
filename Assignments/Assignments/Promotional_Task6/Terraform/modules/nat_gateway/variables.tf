variable "public_subnet_id" {
  description = "ID of the public subnet where the NAT gateway will be created"
  type        = string
}

variable "private_route_table_id" {
  description = "ID of the private route table to associate with the NAT gateway"
  type        = string
}
