# Terraform VPC Setup and Configuration
## Overview
This project sets up a Virtual Private Cloud (VPC) in AWS using Terraform. The configuration includes:
* A VPC with public and private subnets
* Routing tables and NAT Gateway for internet access
* Security Groups and Network Access Control Lists (NACLs)
* EC2 instances in each subnet with scripts to install Nginx and PostgreSQL

### Prerequisites
* Terraform installed
* AWS CLI configured with a profile (For example, PrincessKodeCamp)

### Steps to Deploy
1. Setup AWS CLI Profile

To connect your AWS CLI to your AWS console for the user PrincessKodeCamp and configure it so that Terraform can create a VPC, follow these steps:
* Create an IAM User
  - Go to the IAM section of the AWS Management Console.
  - Create a new user (if not already created) and name it eg PrincessKodeCamp.
  - Grant the user programmatic access by selecting the checkbox for Access key - Programmatic access.
  - Attach the necessary policies for VPC creation. For simplicity, you can attach the AdministratorAccess policy.
* Generate Access Keys and a keypair
  - After creating the user, you'll be given an Access Key ID and a Secret Access Key as well as a keypair. Note these down as you'll need them to configure the AWS CLI.
* Configure AWS CLI
  - Open your terminal or command prompt.
  - Run the following command to configure the AWS CLI:
![Screenshot 2024-07-23 172725](https://github.com/user-attachments/assets/984fc98e-60a4-4f26-ad12-4a0c2e7b6ca0)
  - When prompted, enter the Access Key ID and Secret Access Key for PrincessKodeCamp.
    
        AWS Access Key ID [None]:                YOUR_ACCESS_KEY_ID
        AWS Secret Access Key [None]:         YOUR_SECRET_ACCESS_KEY
        Default region name [None]: eu-west-1
        Default output format [None]: json  # or your preferred output format

2. Verify Configuration
   
To verify that your AWS CLI is configured correctly, you can run a simple command like listing your current VPCs:

    aws ec2 describe-vpcs

If the command returns a list of VPCs or an empty list, your configuration is correct. You can also list your profiles to verify by running:
  
    aws configure list-profiles

### Create Terraform Configuration Files
#### Directory Structure
Create a directory for your project (terraform) and set up the following structure:

     ├── terraform

         └── main.tf

         └── outputs.tf

         └── variables.tf

         └── modules

            ├── ec2_instance

                └── scripts

                   ├── install_nginx.sh

                   ├── install_postgresql.sh

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── nacl

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── nat_gateway

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── route_table

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── security_group

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── vpc

                └── main.tf

                └── outputs.tf

                └── variables.tf

#### Write the Terraform Configuration
terraform/main.tf

    provider "aws" {
      profile = "PrincessKodeCamp"
      region = "eu-west-1"
    }
    
    module "vpc" {
      source   = "./modules/vpc"
      vpc_cidr = "10.0.0.0/16"
    }
    
    module "subnet" {
      source               = "./modules/subnet"
      vpc_id               = module.vpc.vpc_id
      public_subnet_cidr   = "10.0.1.0/24"
      private_subnet_cidr  = "10.0.2.0/24"
      public_subnet_az     = "eu-west-1a"
      private_subnet_az    = "eu-west-1a"
    }
    
    module "route_table" {
      source              = "./modules/route_table"
      vpc_id              = module.vpc.vpc_id
      igw_id              = module.vpc.igw_id
      public_subnet_id    = module.subnet.public_subnet_id
      private_subnet_id   = module.subnet.private_subnet_id
    }
    
    module "nat_gateway" {
      source                  = "./modules/nat_gateway"
      public_subnet_id        = module.subnet.public_subnet_id
      private_route_table_id  = module.route_table.private_route_table_id
    }
    
    module "security_group" {
      source             = "./modules/security_group"
      vpc_id             = module.vpc.vpc_id
      public_subnet_cidr = "10.0.1.0/24"
      my_ip              = "105.112.113.236" # Run curl ifconfig.me on your terminal or visit https://www.whatismyip.com/
    }
    
    module "ec2_instance" {
      source           = "./modules/ec2_instance"
      ami              = "ami-0c38b837cd80f13bb" # Ubuntu Server 24.04 LTS
      instance_type    = "t2.micro"
      public_subnet_id = module.subnet.public_subnet_id
      private_subnet_id = module.subnet.private_subnet_id
      public_sg_id      = module.security_group.public_sg_id
      private_sg_id     = module.security_group.private_sg_id
      key_name           = var.key_name
    }
      
terraform/outputs.tf

    output "vpc_id" {
      value = module.vpc.vpc_id
    }
    
    output "public_subnet_id" {
      value = module.subnet.public_subnet_id
    }
    
    output "private_subnet_id" {
      value = module.subnet.private_subnet_id
    }
    
    output "public_instance_id" {
      value = module.ec2_instance.public_instance_id
    }
    
    output "private_instance_id" {
      value = module.ec2_instance.private_instance_id
    }
    
terraform/variables.tf

    variable "aws_region" {
      description = "The AWS region to deploy in"
      type        = string
      default     = "eu-west-1"
    }
    
    variable "key_name" {
      description = "The name of the key pair to use for SSH access"
      type        = string
    }

terraform/modules/ec2_instance/main.tf

    data "aws_key_pair" "key_pair" {
      key_name           = "KCVPCkeypair"
      include_public_key = true
    }
    
    resource "aws_instance" "public_instance" {
      ami                    = var.ami
      instance_type          = var.instance_type
      subnet_id              = var.public_subnet_id
      security_groups         = [var.public_sg_id]
      associate_public_ip_address = true
      key_name                    = data.aws_key_pair.key_pair.key_name
    
    
      user_data = file("${path.module}/scripts/scripts/install_nginx.sh")
    
      tags = {
        Name = "PublicInstance"
      }
    }
    
    resource "aws_instance" "private_instance" {
      ami               = var.ami
      instance_type     = var.instance_type
      subnet_id         = var.private_subnet_id
      security_groups    = [var.private_sg_id]
      key_name                    = data.aws_key_pair.key_pair.key_name
    
      user_data = file("${path.module}/scripts/scripts/install_postgresql.sh")
    
      tags = {
        Name = "PrivateInstance"
      }
    }
        
terraform/modules/ec2_instance/outputs.tf

    output "public_instance_id" {
      value = aws_instance.public_instance.id
    }
    
    output "private_instance_id" {
      value = aws_instance.private_instance.id
    }

terraform/modules/ec2_instance/variables.tf

    variable "ami" {
      description = "The AMI ID"
      type        = string
    }
    
    variable "instance_type" {
      description = "The instance type"
      type        = string
    }
    
    variable "public_subnet_id" {
      description = "The public subnet ID"
      type        = string
    }
    
    variable "private_subnet_id" {
      description = "The private subnet ID"
      type        = string
    }
    
    variable "public_sg_id" {
      description = "The public security group ID"
      type        = string
    }
    
    variable "private_sg_id" {
      description = "The private security group ID"
      type        = string
    }

terraform/modules/ec2_instance/scripts/scripts/install_nginx.sh

    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx

terraform/modules/ec2_instance/scripts/scripts/install_postgresql.sh

    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql

### Initialize Terraform
* Navigate to the root directory (terraform) and initialize Terraform 
(Run the command terraform init): ![Screenshot 2024-07-23 172830](https://github.com/user-attachments/assets/ee0ebd2d-cad4-43ae-b3eb-1f10a88d6b8c)
![Screenshot (80)](https://github.com/user-attachments/assets/52146bea-e1ab-45df-bce4-2d95e754e139)
* Check if the configuration is valid and Run terraform plan if the configuration is valid
![Screenshot 2024-07-24 003547](https://github.com/user-attachments/assets/20c579a0-4f0a-4c54-8e78-a5483ec9b7d2) ![Screenshot (83)](https://github.com/user-attachments/assets/8305096c-7268-462c-b0e1-9416728b4179) ![Screenshot (84)](https://github.com/user-attachments/assets/e1bd7d4c-d160-4430-aa72-e1d971de8631) ![Screenshot (85)](https://github.com/user-attachments/assets/b0ff5390-0347-443f-9d7d-3814d0b220e5) ![Screenshot (86)](https://github.com/user-attachments/assets/fc531e64-dccd-4502-8191-ea284e1f79f0) ![Screenshot (87)](https://github.com/user-attachments/assets/6d247b22-2a46-4556-8d9b-cf839d0c02e3) ![Screenshot (88)](https://github.com/user-attachments/assets/a5da0219-a3ec-4edb-8829-f3fb9174b6bd) ![Screenshot (90)](https://github.com/user-attachments/assets/a19d1efa-f69e-4055-a95c-568721812c37) ![Screenshot (92)](https://github.com/user-attachments/assets/5f7f90ba-ec06-4d40-8434-1267ca7a2fa5) ![Screenshot (93)](https://github.com/user-attachments/assets/6dc76a74-7b06-4eef-b333-681709de7dae) ![Screenshot (94)](https://github.com/user-attachments/assets/8b8a7ccd-67d3-4af1-88ca-59dad432a7d0) ![Screenshot (95)](https://github.com/user-attachments/assets/d413ad6a-8452-4f12-9349-a5b6e9189397) ![Screenshot (96)](https://github.com/user-attachments/assets/0e00331b-ebab-4923-8e1a-00e831b25b1e) ![Screenshot (97)](https://github.com/user-attachments/assets/696c41e4-0674-44d0-a3f0-b52c97f577e3) ![Screenshot (98)](https://github.com/user-attachments/assets/fd18ab0f-fbc7-4c79-b154-b531af35d2c5) ![Screenshot (99)](https://github.com/user-attachments/assets/4ad66c32-65f6-494a-914e-b019a412db8d)

### Review Configuration
* Run a plan to review the changes Terraform will make by running the command:

      terraform plan -out=tfplan.out
  
![Screenshot (103)](https://github.com/user-attachments/assets/5be0187d-9657-44da-8ac4-00a2ccdf064b)
### Apply Configuration
Apply the Terraform configuration to create the resources:
![Screenshot (102)](https://github.com/user-attachments/assets/301fa040-3456-4e70-913e-5381422315b8) ![Screenshot (104)](https://github.com/user-attachments/assets/371dab35-7e45-47b0-8187-9524a1de724a) 

### Verify Resources
After applying, check the AWS Console to verify the following:
* VPC creation
* Subnets (Public and Private)
* Route Tables and NAT Gateway
* Security Groups
* Network ACLs
* EC2 Instances in respective subnets

### Test EC2 Instances
* Public Instance: Ensure Nginx is installed and accessible via HTTP (port 80).
* Private Instance: Ensure PostgreSQL is installed and accessible from the public instance.

### Make the tfplan show in a json file
![Screenshot (105)](https://github.com/user-attachments/assets/43f4d6e5-f447-4d55-97d7-ffcf92b21449)

### Login to your AWS Console to verify that all the resources were created
![Screenshot (110)](https://github.com/user-attachments/assets/56cdaa3c-5c52-4f5d-b793-4ab9812d8714) ![Screenshot (111)](https://github.com/user-attachments/assets/208e013b-1357-4724-9bb1-904216b83da0) ![Screenshot (112)](https://github.com/user-attachments/assets/76b520f9-5575-47d4-bbec-9e6bbed402da) ![Screenshot (113)](https://github.com/user-attachments/assets/38b0991f-5f3c-403d-b771-141b45b45c71) ![Screenshot (114)](https://github.com/user-attachments/assets/6c5d839b-041a-44a1-ba36-376563298ba8) ![Screenshot (115)](https://github.com/user-attachments/assets/43be3485-2986-4f06-91bb-559ea550b2ef) ![Screenshot (116)](https://github.com/user-attachments/assets/c963e9b3-8123-41f0-8dc1-a1c458b65d98) ![Screenshot (106)](https://github.com/user-attachments/assets/6fc108bb-fe43-42d1-b5ac-f4ea131af70f) ![Screenshot (107)](https://github.com/user-attachments/assets/bb4906fe-ee36-43b4-9983-9b8e6be9abf8) ![Screenshot (108)](https://github.com/user-attachments/assets/a67334ed-0170-4dfb-9b23-94831bbf5f76)
### Destroy Resources
To clean up all resources created by Terraform, run 

    terraform destroy

![Screenshot (117)](https://github.com/user-attachments/assets/85c11837-82b1-4391-a612-aa48ee494276) ![Screenshot (118)](https://github.com/user-attachments/assets/3f57467a-36a9-4a3a-8d35-9589d876715a) ![Screenshot (119)](https://github.com/user-attachments/assets/3faaacf1-9006-4f83-8fd6-c4f2b05e9e75) ![Screenshot (120)](https://github.com/user-attachments/assets/3a749053-73f0-4ce3-a600-7886493bc8fc)

### Module Descriptions
* vpc: Configures the VPC, public and private subnets.
* nat_gateway: Sets up the NAT Gateway for private subnet internet access.
* route_table: Manages routing tables for public and private subnets.
* security_group: Defines security groups for public and private EC2 instances.
* nacl: Configures Network ACLs for inbound and outbound traffic.
* ec2_instance: Launches EC2 instances with user data scripts for software installation.

### Variables
* aws_region: AWS region for resource deployment.
* vpc_cidr: CIDR block for the VPC.
* public_subnet_cidr: CIDR block for the public subnet.
* private_subnet_cidr: CIDR block for the private subnet.
* availability_zone (az): Availability Zone for subnets.
* ssh_cidr: CIDR block allowed to SSH into public instances.
* vpc_cidr: CIDR block for the VPC.
* public_instance_ami: AMI ID for the public EC2 instance.
* private_instance_ami: AMI ID for the private EC2 instance.
* instance_type: Type of EC2 instance.

### Outputs
* vpc_id: The ID of the created VPC.
* public_subnet_id: The ID of the public subnet.
* private_subnet_id: The ID of the private subnet.
* nat_gateway_id: The ID of the NAT Gateway.
* public_sg_id: The ID of the public security group.
* private_sg_id: The ID of the private security group.
* public_instance_id: The ID of the public EC2 instance.
* private_instance_id: The ID of the private EC2 instance.
* public_nacl_id: The ID of the public subnet NACL.
* private_nacl_id: The ID of the private subnet NACL.

### Architecture Diagram

https://excalidraw.com/#json=tXyVFfe7NzA7fEr1YRIBj,6sZlIHEA3khMk-QYMwCJYg ![Screenshot (67)](https://github.com/user-attachments/assets/7a98dfbb-903d-4444-b8c6-019e8bb3f5a5)


### Explanation of Components
* VPC (Virtual Private Cloud): A logically isolated section of the AWS cloud where you can launch AWS resources in a virtual network you define.
Subnets:
* Public Subnet: A subnet with a route to the internet via the Internet Gateway (IGW).
* Private Subnet: A subnet without a direct route to the internet but can access it via the NAT Gateway.
* Internet Gateway (IGW): A horizontally scaled, redundant, and highly available VPC component that allows communication between instances in your VPC and the internet.
* Route Tables:
   - Public Route Table: Routes traffic to the internet via the IGW.
   - Private Route Table: Routes traffic to the internet via the NAT Gateway.
* NAT Gateway: Allows instances in a private subnet to connect to the internet or other AWS services but prevents the internet from initiating connections with the instances.
* Security Groups: Virtual firewalls that control inbound and outbound traffic for AWS resources.
* Network ACLs (NACLs): Optional layer of security that acts as a firewall for controlling traffic in and out of one or more subnets.
###Conclusion

This README.md file detailed the process of setting up a VPC with public and private subnets, configuring routing, security groups, and NACLs, and deploying EC2 instances to ensure proper communication and security within the VPC using Terraform.
