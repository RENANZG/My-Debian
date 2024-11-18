#!/bin/bash

# Variables
VPC_NAME="VPC"
VPC_CIDR="192.168.0.0/18"
PUBLIC_SUBNET_CIDR="192.168.1.0/26"
REGION="cl-1"  # Change to your desired region

# Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --output text --query 'Vpc.VpcId')
echo "VPC Created: $VPC_ID"

# Tag VPC
echo "Tagging VPC..."
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION

# Create Public Subnet
echo "Creating Public Subnet..."
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_CIDR --availability-zone ${REGION}a --output text --query 'Subnet.SubnetId')
echo "Public Subnet Created: $PUBLIC_SUBNET_ID"

# Tag Public Subnet
echo "Tagging Public Subnet..."
aws ec2 create-tags --resources $PUBLIC_SUBNET_ID --tags Key=Name,Value=${VPC_NAME}-PublicSubnet --region $REGION

# Create Internet Gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --output text --query 'InternetGateway.InternetGatewayId')
echo "Internet Gateway Created: $IGW_ID"

# Attach Internet Gateway to VPC
echo "Attaching Internet Gateway to VPC..."
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID --region $REGION

# Create Route Table
echo "Creating Route Table..."
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --output text --query 'RouteTable.RouteTableId')
echo "Route Table Created: $RT_ID"

# Tag Route Table
echo "Tagging Route Table..."
aws ec2 create-tags --resources $RT_ID --tags Key=Name,Value=${VPC_NAME}-RouteTable --region $REGION

# Create Route to Internet Gateway
echo "Creating Route to Internet Gateway..."
aws ec2 create-route --route-table-id $RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION

# Associate Route Table with Public Subnet
echo "Associating Route Table with Public Subnet..."
aws ec2 associate-route-table --route-table-id $RT_ID --subnet-id $PUBLIC_SUBNET_ID --region $REGION

# Enable DNS Support and DNS Hostnames for the VPC
echo "Enabling DNS Support and DNS Hostnames..."
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support "{\"Value\":true}" --region $REGION
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames "{\"Value\":true}" --region $REGION

echo "VPC setup is complete."
