provider "aws" {
  profile = "PrincessKodeCamp"
  region  = var.aws_region
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone  = var.availability_zone
}

module "nat_gateway" {
  source      = "./modules/nat_gateway"
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_id
}

module "public_route_table" {
  source       = "./modules/route_table"
  vpc_id       = module.vpc.vpc_id
  igw_id       = module.vpc.igw_id
  subnet_ids   = [module.vpc.public_subnet_id]
  is_public    = true
}

module "private_route_table" {
  source          = "./modules/route_table"
  vpc_id          = module.vpc.vpc_id
  nat_gateway_id  = module.nat_gateway.nat_gateway_id
  subnet_ids      = [module.vpc.private_subnet_id]
  is_public       = false
}

module "public_sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  type   = "public"
  ssh_cidr = var.ssh_cidr
}

module "private_sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  type   = "private"
}

module "public_instance" {
  source          = "./modules/ec2_instance"
  subnet_id       = module.vpc.public_subnet_id
  security_group  = module.public_sg.security_group_id
  script_path     = var.public_instance_script_path
  ami             = var.public_instance_ami
  instance_type   = var.instance_type
}

module "private_instance" {
  source          = "./modules/ec2_instance"
  subnet_id       = module.vpc.private_subnet_id
  security_group  = module.private_sg.security_group_id
  script_path     = var.private_instance_script_path
  ami             = var.private_instance_ami
  instance_type   = var.instance_type
}