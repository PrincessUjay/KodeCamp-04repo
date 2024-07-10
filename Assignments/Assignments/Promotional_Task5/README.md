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
- Conclusion

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

![Screenshot (48)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/d10344fe-38e0-4dc8-9162-ac0f7cf0ecfb)

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

![Screenshot (49)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/aa864eea-7150-4e7a-baf0-3f813733796e)

### Step 3: Configure Internet Gateway
a. Navigate to the Internet Gateways section in the left-hand menu.

b. Click on "Create Internet Gateway"

c. To Create and attach an IGW to KCVPC, fill in the details:
- Name Tag: KCVPC-IGW
- Click "Create Internet Gateway"
- Attach the internet gateway by selecting the created IGW.
- Click on "Actions" and select "Attach to VPC".
- Select 'KCVPC' and click "Attach".

![Screenshot (50)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/5d9e9b5b-486e-4111-98e8-3b61b5f752db)

### Step 4: Configure Route Tables
a. Navigate to the Route Tables section in the left-hand Menu

b. Click on "Create Route Table" and fill in the details:

Public Route Table:
- Name: PublicRouteTable
- VPC: Select the 'KCVPC' VPC you created.
- Click "Create Route Table".
- To Add a route to the IGW (0.0.0.0/0 -> IGW), and Associate PublicSubnet with this route table:
  - Select the created route table, click on the "Routes" Tab, and then "Edit Routes".
  - Click on "Add route"
  - Set Destination to 0.0.0.0/0 and Target to the Internet Gateway 'KCVPC-IGW'.
  - Click "Save Changes"
  - Go to the "subnet associations" tab and click on "Edit subnet associations".
  - Select "PublicSubnet" and Click "Save associations".
 
![Screenshot (51)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/efebb9fa-91d8-4fac-b7f0-674bc92f6848)

Private Route Table:
- Click on "Create route table" again.
- Name: PrivateRouteTable
- VPC: Select the 'KCVPC' VPC you created.
- Click "Create Route Table".
- To Associate PrivateSubnet with this route table:
  - Go to the "subnet associations" tab and click on "Edit subnet associations".
  - Select "PrivateSubnet" and Click "Save associations"
N/B: Ensure no direct route to the internet.

![Screenshot (52)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/895d31a8-b11b-43be-a27c-6c8a0c71a4de)

### Step 5: Configure NAT Gateway
a. Navigate to the NAT Gateways section in the left-hand menu.

b. Click on "Create NAT gateway" and Fill in the details:
  - Subnet: Select PublicSubnet
  - Elastic IP Allocation ID: Click on "Allocate Elastic IP" and select it.
- Click "Create NAT gateway".
  
c. To Update the Private Route Table:
  - Navigate to the Route Tables section in the left-hand Menu
  - Select the PrivateRouteTable.
  - Go to the "Routes" tab and click "Edit routes".
  - Click on "Add route", set Destination to 0.0.0.0/0, and Target to the created NAT Gateway.
  - Click "Save Changes".

![Screenshot (53)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/6797656f-7a55-40d8-9fe9-0af68ef9e4b4)

### Step 6: Set Up Security Groups
For Public Security Group:

a. Navigate to the Security Groups section in the left-hand menu.

b. Click on "Create security group" and Fill in the details:
- Security group Name: PublicSG
- Description: Security group for public instances
- VPC: Select the 'KCVPC' VPC you created.
- Click "Create security group".
  
c. To Edit Inbound Rules:
- Select the created security group.
Go to the "Inbound rules" tab and click "Edit inbound rules".
- Add rules for:
  - HTTP (port 80) from 0.0.0.0/0
  - HTTPS (port 443) from 0.0.0.0/0
  - SSH (port 22) from your specific IP (check https://www.whatismyip.com/) i.e type in the IP as a custom one with CIDR notation (for mine: 32)
- Click "Save rules".

![Screenshot (55)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/09c7e69f-1bf3-46e8-a895-c537ee0df158)

d. To Edit Outbound Rules:
- Go to the "Outbound rules" tab and click "Edit Outbound rules" 
- Add a new rule:
  - Type: All traffic.
  - Protocol: All
  - Port Range: All
  - Destination: 0.0.0.0/0 (This will Allow all outbound traffic to any IP address)
- Click "Save rules".

![Screenshot (56)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/b18527ca-3665-4150-8e47-1e7a6dbd88a9)

For Private Security Group:

a. Click on Security Groups and then click "Create security group" again and Fill in the details:
- Security group Name: PrivateSG
- Description: Security group for private instances
- VPC: Select the 'KCVPC' VPC you created.
- Click "Create security group".

b. To Edit Inbound Rules:
- Select the created security group.
- Go to the "Inbound rules" tab and click "Edit inbound rules".
- Click "Add rule" and fill in the details:
  - MySQL (port 3306) from PublicSubnet    - CIDR block (10.0.1.0/24)
  - Click "Save rules".

c. To Edit Outbound Rules:
- Go to the "Outbound rules" tab and click "Edit Outbound rules" 
- Add a new rule:
  - Type: All traffic.
  - Protocol: All
  - Port Range: All
  - Destination: 0.0.0.0/0 (This will Allow all outbound traffic to any IP address)
- Click "Save rules".
N/B: you can also allow it by default.

![Screenshot (57)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/d6881364-ec31-4c13-aa32-d7acc3eb11b6)

### Step 7: Configure Network ACLs (NACLs)
For Public Subnet NACL:

a. Navigate to the Network ACLs section in the left-hand menu.

b. Click on "Create network ACL" and Fill in the details:
- Name tag: PublicNACL
- VPC: Select KCVPC
- Click "Create network ACL".

c. To Edit Inbound Rules:
- Select the created NACL.
- Go to the "Inbound rules" tab and click "Edit inbound rules".
- Click "add new rule" and Add the following rules:
  - Rule #: 1, Type: HTTP, Protocol: TCP, Port Range: 80, Source: 0.0.0.0/0, Allow/Deny: Allow
  - Rule #: 2, Type: HTTPS, Protocol: TCP, Port Range: 443, Source: 0.0.0.0/0, Allow/Deny: Allow
  - Rule #: 3, Type: SSH, Protocol: TCP, Port Range: 22, Source: <your IP>/32 (use your own public IP), Allow/Deny: Allow
  - Click "Save rules".

d. To Edit Outbound Rules:
- Go to the "Outbound rules" tab and click "Edit Outbound rules" 
- Add a new rule 1:
  - Type: All traffic.
  - Protocol: All
  - Port Range: All
  - Destination: 0.0.0.0/0 (This will Allow all outbound traffic to any IP address)
- Click "Save rules".

![Screenshot (58)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/145cc1a1-0ed4-433b-8178-2125ad648e06)

For Private Subnet NACL:
a. Click on "Create network ACL" again and Fill in the details:
- Name tag: PrivateNACL
- VPC: Select KCVPC
- Click "Create network ACL".

b. To Edit Inbound Rules:
- Select the created NACL.
- Go to the "Inbound rules" tab and click "Edit inbound rules".
- Add rules for:
  - Allow traffic from the public subnet (10.0.1.0/24) on necessary ports.
(e.g., MySQL port 3306)
  - Click "Save rules".
    
c. To Edit Outbound Rules:
- Go to the "Outbound rules" tab and click "Edit Outbound rules" 
- Add the following rules:
  - Allow Outbound Traffic to the Public Subnet:
    - Rule #: 1
    - Type: All Traffic
    - Protocol: All
    - Port Range: All
    - Destination: 10.0.1.0/24 (Public Subnet CIDR)
    - Allow/Deny: Allow
    - Purpose: This rule ensures that any traffic originating from the private subnet can communicate with resources in the public subnet.
  - Allow Outbound Traffic to the Internet through the NAT Gateway:
    - Rule #: 2
    - Type: All Traffic
    - Protocol: All
    - Port Range: All
    - Destination: 0.0.0.0/0
    - Allow/Deny: Allow
    - Purpose: This rule ensures that any traffic from the private subnet can access the internet via the NAT Gateway, allowing instances in the private subnet to reach external resources while remaining hidden from the internet.

![Screenshot (59)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/8a61192e-7579-456a-b008-aee96888d818)

d. Associating NACLs with Subnets:

Associate Public Subnet NACL:
- In the Network ACLs list, select PublicNACL.
- Go to the "Subnet associations" tab.
- Click "Edit subnet associations".
- Select the PublicSubnet and click "Save changes".
Associate Private Subnet NACL:
- In the Network ACLs list, select PrivateNACL.
- Go to the "Subnet associations" tab.
- Click "Edit subnet associations".
- Select the PrivateSubnet and click "Save changes".

![Screenshot (60)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/e7b6afc5-075a-43d2-895d-fec8efdc2933)

### Step 8: Deploy Instances
To Launch an EC2 Instance in the Public Subnet:

a. Navigate to the EC2 Dashboard.

b. Click on "Launch instance" and Fill in the details:
- Name: PublicInstance
- AMI: Choose an appropriate AMI (e.g., Amazon Linux 2)
- Instance type: Choose an appropriate type (e.g., t2.micro)
- Key pair: Select an existing key pair or create a new one.

For Network settings:
- VPC: Select KCVPC
- Subnet: Select PublicSubnet
- Auto-assign Public IP: Enable
- Security group: Select PublicSG
- Click "Launch instance" and complete the wizard.
- Verify that the instance can be accessed via SSH using the public IP.

To Launch an EC2 Instance in the Private Subnet:

a. Click on "Launch instance" again and Fill in the details:
- Name: PrivateInstance
- AMI: Choose an appropriate AMI (e.g., Amazon Linux 2)
- Instance type: Choose an appropriate type (e.g., t2.micro)
- Key pair: Select an existing key pair or create a new one.

For Network settings:
- VPC: Select KCVPC
- Subnet: Select PrivateSubnet
- Auto-assign Public IP: Disable
- Security group: Select PrivateSG
- Click "Launch instance" and complete the wizard.
- Verify that the instance can access the internet through the NAT Gateway by updating the instance and installing packages.
- Verify that the instance can communicate with the public instance.

### Architecture Diagram
https://excalidraw.com/#json=tXyVFfe7NzA7fEr1YRIBj,6sZlIHEA3khMk-QYMwCJYg
![Screenshot (54)](https://github.com/PrincessUjay/KodeCamp-04repo/assets/74983978/ce43ef7e-2806-41cf-9bd3-d8f8ae636f76)

### Explanation of Components
- VPC (Virtual Private Cloud): A logically isolated section of the AWS cloud where you can launch AWS resources in a virtual network you define.
- Subnets:
  - Public Subnet: A subnet with a route to the internet via the Internet Gateway (IGW).
  - Private Subnet: A subnet without a direct route to the internet but can access it via the NAT Gateway.
- Internet Gateway (IGW): A horizontally scaled, redundant, and highly available VPC component that allows communication between instances in your VPC and the internet.
- Route Tables:
  - Public Route Table: Routes traffic to the internet via the IGW.
  - Private Route Table: Routes traffic to the internet via the NAT Gateway.
- NAT Gateway: Allows instances in a private subnet to connect to the internet or other AWS services but prevents the internet from initiating connections with the instances.
- Security Groups: Virtual firewalls that control inbound and outbound traffic for AWS resources.
- Network ACLs (NACLs): Optional layer of security that acts as a firewall for controlling traffic in and out of one or more subnets.

### Conclusion
This README.md file detailed the process of setting up a VPC with public and private subnets, configuring routing, security groups, and NACLs, and deploying EC2 instances to ensure proper communication and security within the VPC.
