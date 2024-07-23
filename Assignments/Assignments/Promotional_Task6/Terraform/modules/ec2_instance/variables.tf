variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched"
  type        = string
}

variable "security_group" {
  description = "The ID of the security group to associate with the instance"
  type        = string
}

variable "script_path" {
  description = "The path to the script to run on instance launch"
  type        = string
}