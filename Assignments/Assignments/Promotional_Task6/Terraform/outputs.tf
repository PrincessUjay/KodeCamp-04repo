output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_instance_ip" {
  value = module.ec2_public.public_ip
}