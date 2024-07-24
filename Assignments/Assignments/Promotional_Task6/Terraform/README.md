
# Terraform VPC Setup and Configuration
### Overview
This project sets up a Virtual Private Cloud (VPC) in AWS using Terraform. The configuration includes:

* A VPC with public and private subnets
* Routing tables and NAT Gateway for internet access
* Security Groups and Network Access Control Lists (NACLs)
* EC2 instances in each subnet with scripts to install Nginx and PostgreSQL

### Prerequisites

* Terraform installed
* AWS CLI configured with a profile (For example, PrincessKodeCamp)

### Directory Structure
Add screenshot here

### Steps to Deploy
1. Setup AWS CLI Profile

To connect your AWS CLI to your AWS console for the user PrincessKodeCamp and configure it so that Terraform can create a VPC, follow these steps:
* Create an IAM User
  - Go to the IAM section of the AWS Management Console.
  - Create a new user (if not already created) and name it eg PrincessKodeCamp.
  - Grant the user programmatic access by selecting the checkbox for Access key - Programmatic access.
  - Attach the necessary policies for VPC creation. For simplicity, you can attach the AdministratorAccess policy.
* Generate Access Keys
  - After creating the user, you'll be given an Access Key ID and a Secret Access Key. Note these down as you'll need them to configure the AWS CLI.
* Configure AWS CLI
  - Open your terminal or command prompt.
  - Run the following command to configure the AWS CLI:
Screenshot of aws configure --profile PrincessKodeCamp
  - When prompted, enter the Access Key ID and Secret Access Key for PrincessKodeCamp.

AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: eu-west-1
Default output format [None]: json  # or your preferred output format

2. Verify Configuration
To verify that your AWS CLI is configured correctly, you can run a simple command like listing your current VPCs:

Screenshot of aws ec2 describe-vpcs

If the command returns a list of VPCs or an empty list, your configuration is correct.
Or you can list your profiles to verify by running:
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


### Initialize Terraform
Navigate to the root directory and initialize Terraform:
terraform init

### Review Configuration
Run a plan to review the changes Terraform will make:
terraform plan -out=tfplan.out

### Apply Configuration
Apply the Terraform configuration to create the resources:

Screenshot 

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

### Destroy Resources
To clean up all resources created by Terraform, run:
Screenshot 

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
* availability_zone: Availability Zone for subnets.
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

https://excalidraw.com/#json=tXyVFfe7NzA7fEr1YRIBj,6sZlIHEA3khMk-QYMwCJYg Screenshot (67)

Explanation of Components
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
