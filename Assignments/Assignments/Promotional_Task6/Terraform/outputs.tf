output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "public_sg_id" {
  value = module.public_sg.security_group_id
}

output "private_sg_id" {
  value = module.private_sg.security_group_id
}

output "public_instance_id" {
  value = module.public_instance.instance_id
}

output "private_instance_id" {
  value = module.private_instance.instance_id
}