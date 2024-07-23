variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "The availability zone to use for the subnets"
  type        = string
  default     = "eu-west-1a"
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "public_instance_ami" {
  description = "The AMI ID for the public instance"
  type        = string
  default     = "ami-0c21ae4a6fdadacc0"  # Ubuntu 20.04 LTS in eu-west-1
}

variable "private_instance_ami" {
  description = "The AMI ID for the private instance"
  type        = string
  default     = "ami-0c21ae4a6fdadacc0"  # Ubuntu 20.04 LTS in eu-west-1
}

variable "ssh_cidr" {
  description = "The CIDR block allowed to access the instances via SSH"
  type        = string
  default     = "YOUR_LOCAL_IP/32"
}

variable "public_instance_script_path" {
  description = "The path to the script to run on the public instance"
  type        = string
  default     = "./scripts/install_nginx.sh"
}

variable "private_instance_script_path" {
  description = "The path to the script to run on the private instance"
  type        = string
  default     = "./scripts/install_postgresql.sh"
}