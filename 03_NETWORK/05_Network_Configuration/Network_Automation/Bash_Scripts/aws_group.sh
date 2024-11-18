#!/bin/bash

# Title: AWS VPS Setup
# Author: Me and the bois
# Date: 2024
# ASCII Diagram:
#
#       +-----------------------------------+
#       |            AWS Cloud              |
#       |  +-----------------------------+  |
#       |  |            VPS              |  |
#       |  |   (CIDR: 192.168.0.0/18)    |  |
#       |  |                             |  |
#       |  | +------------------------+  |  |
#       |  | |    Internet Gateway    |  |  |
#       |  | +------------------------+  |  |
#       |  |                             |  |
#       |  | +------------------------+  |  |
#       |  | |      Public Subnet     |  |  |
#       |  | | (CIDR: 192.168.1.0/26) |  |  |
#       |  | |                        |  |  |
#       |  | | +--------------------+ |  |  |
#       |  | | |  Security Group    | |  |  |
#       |  | | +--------------------+ |  |  |
#       |  | |  +-------------------+ |  |  |
#       |  | |  |  EC2 Instance     | |  |  |
#       |  | |  +-------------------+ |  |  |
#       |  | +------------------------+  |  |
#       |  +-----------------------------+  |
#       +-----------------------------------+

# Variables
VPC_CIDR="192.168.0.0/18"
SUBNET_CIDR="192.168.1.0/26"
REGION="cl-1"
KEY_NAME="AWSKeyPair"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-774yhjtg8gh495uj"  # Replace with the appropriate Amazon Linux 2023 AMI ID for your region

# Step 1: Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
echo "Created VPC with ID: $VPC_ID"

# Step 2: Create Subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --region $REGION --query 'Subnet.SubnetId' --output text)
echo "Created Subnet with ID: $SUBNET_ID"

# Step 3: Create Internet Gateway and attach to VPC
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
echo "Created and attached Internet Gateway with ID: $IGW_ID"

# Step 4: Create Route Table and associate it with the Subnet
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID --region $REGION
echo "Created and associated Route Table with ID: $ROUTE_TABLE_ID"

# Step 5: Create Network ACL and associate it with the Subnet
NACL_ID=$(aws ec2 create-network-acl --vpc-id $VPC_ID --region $REGION --query 'NetworkAcl.NetworkAclId' --output text)
aws ec2 create-network-acl-entry --network-acl-id $NACL_ID --region $REGION --ingress --rule-number 100 --protocol -1 --port-range From=0,To=65535 --cidr-block 0.0.0.0/0 --rule-action allow
aws ec2 create-network-acl-entry --network-acl-id $NACL_ID --region $REGION --egress --rule-number 100 --protocol -1 --port-range From=0,To=65535 --cidr-block 0.0.0.0/0 --rule-action allow
aws ec2 associate-network-acl --network-acl-id $NACL_ID --subnet-id $SUBNET_ID --region $REGION
echo "Created and associated Network ACL with ID: $NACL_ID"

# Step 6: Create Security Group
SG_ID=$(aws ec2 create-security-group --group-name "public-security-group" --description "Allows public access" --vpc-id $VPC_ID --region $REGION --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $REGION
echo "Created Security Group with ID: $SG_ID"

# Step 7: Launch EC2 Instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_ID --subnet-id $SUBNET_ID --associate-public-ip-address --region $REGION --query 'Instances[0].InstanceId' --output text)
echo "Launched EC2 Instance with ID: $INSTANCE_ID"

# Output the public IP of the instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --region $REGION --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "EC2 Instance Public IP: $PUBLIC_IP"

echo "All resources have been created successfully. You can now SSH into your EC2 instance using the following command:"

echo "ssh -i /path/to/$KEY_NAME.pem ec2-user@$PUBLIC_IP"
