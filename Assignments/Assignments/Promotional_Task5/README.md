# KCVPC Setup and Configuration

### OBJECTIVE
Design and set up a Virtual Private Cloud (VPC) with both public and private subnets. Implement routing, security groups, and network access control lists (NACLs) to ensure proper communication and security within the VPC in the AWS EU-West-1 (Ireland) region.

## Table of Contents
- Introduction
- Create VPC
- Create Subnets
- Configure Internet Gateway
- Configure Route Tables
- Configure NAT Gateway
- Set Up Security Groups
- Configure Network ACLs
- Deploy Instances
- Architecture Diagram
- Explanation of Components

### Introduction
This README.md File details the steps to create and configure a Virtual Private Cloud (VPC) named KCVPC with public and private subnets, and appropriate routing and security configurations.

### Step 1: Create VPC
a. Open your AWS Console (console.aws.amazon.com) and Navigate to VPC Dashboard in the AWS Management Console.

b. Click on "Your VPCs" in the left-hand menu.

c. Click on "Create VPC" and Create a VPC with the following details:
- Name Tag: KCVPC
- IPv4 CIDR block: 10.0.0.0/16

d. Leave the default settings for other fields

e. Click "Create VPC".

### Step 2: Create Subnets
a. Navigate to the Subnets section in the left-hand menu.

b. Click on "Create Subnet" and create these subnets with the following details:

Public Subnet
- VPC: Select the 'KCVPC' VPC you created.
- Subnet Name: PublicSubnet
- IPv4 CIDR block: 10.0.1.0/24
- Availability Zone: Select one (e.g., I selected eu-west-1a)

Click add new subnet and create a private subnet

Private Subnet
- VPC: Select the 'KCVPC' VPC you created.
- Subnet Name: PrivateSubnet
- IPv4 CIDR block: 10.0.2.0/24
- Availability Zone: Select one (e.g., I selected eu-west-1a)

c. Click "Create Subnet".

### Step 3: Configure Internet Gateway
a. Navigate to the Internet Gateways section in the left-hand menu.

b. Click on "Create Internet Gateway"

c. To Create and attach an IGW to KCVPC, fill in the details:
- Name Tag: KCVPC-IGW
- Click "Create Internet Gateway"
- Attach the internet gateway by selecting the created IGW.
- Click on "Actions" and select "Attach to VPC".
- Select 'KCVPC' and click "Attach".

### Step 4: Configure Route Tables
a. Navigate to the Route Tbles section in the left-hand Menu

b. Click on "Create Route Table" and fill in the details:

Public Route Table:
- Name Tag: PublicRouteTable
- Associate PublicSubnet with this route table.
- Add a route to the IGW (0.0.0.0/0 -> IGW).

Private Route Table:
- Name Tag: PrivateRouteTable
- Associate PrivateSubnet with this route table.
- Ensure no direct route to the internet.

### Step 5: Configure NAT Gateway
- Create a NAT Gateway in the PublicSubnet.
- Allocate an Elastic IP for the NAT Gateway.
- Update the PrivateRouteTable to route internet traffic (0.0.0.0/0) to the NAT Gateway.

### Step 6: Set Up Security Groups
Public Security Group:
- Allow inbound HTTP (port 80) and HTTPS (port 443) traffic from anywhere (0.0.0.0/0).
- Allow inbound SSH (port 22) traffic from your local IP.
- Allow all outbound traffic.

Private Security Group:
- Allow inbound traffic from the PublicSubnet on required ports (e.g., MySQL port 3306).
- Allow all outbound traffic.

### Step 7: Configure Network ACLs
Public Subnet NACL:
- Allow inbound HTTP, HTTPS, and SSH traffic.
- Allow all outbound traffic.

Private Subnet NACL:
- Allow inbound traffic from the public subnet.
- Allow outbound traffic to the public subnet and internet.

### Step 8: Deploy Instances
- Launch an EC2 instance in the PublicSubnet using the public security group.

• Verify that the instance can be accessed via the internet.
- Launch an EC2 instance in the PrivateSubnet using the private security group.

• Verify that the instance can access the internet through the NAT Gateway and communicate with the public instance.

### Architecture Diagram
Screenshots 

### Explanation of Components
- VPC (Virtual Private Cloud): Provides a logically isolated section of the AWS cloud where you can launch AWS resources in a virtual network that you define.
- Subnets: Divide the VPC's IP address range into smaller segments and route traffic within the VPC.
- Internet Gateway (IGW): Allows instances in the VPC to connect to the internet.
- NAT Gateway: Enables instances in the private subnet to connect to the internet while preventing the internet from initiating connections with those instances.
- Route Tables: Determines where network traffic is directed.
- Security Groups: Acts as a virtual firewall for your instances to control inbound and outbound traffic.
- Network ACLs (NACLs): Provides an additional layer of security by controlling traffic to and from the subnet.

### Conclusion

### References
