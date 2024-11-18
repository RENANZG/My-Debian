#!/bin/bash

# Set variables - Replace with your values or fetch dynamically
REGION="us-east-1"  # Set the AWS Region
VPC_ID="vpc-12345678"  # Set your VPC ID
SUBNET_PUBLIC_1="subnet-11111111"  # Set your public subnet 1
SUBNET_PUBLIC_2="subnet-22222222"  # Set your public subnet 2
SUBNET_PRIVATE_1="subnet-33333333"  # Set your private subnet 1
SUBNET_PRIVATE_2="subnet-44444444"  # Set your private subnet 2
SECURITY_GROUP_ID="sg-12345678"  # Set your Security Group ID
KEY_NAME="YourKeyName"  # Set your EC2 Key Pair Name
AMI_ID="ami-0c55b159cbfafe1f0"  # Set your AMI ID for Amazon Linux 2
USER_DATA_FILE="/home/ec2-user/UserData.txt"  # Path to your user-data script

# Configure AWS CLI
aws configure set default.region $REGION

# Create ALB
echo "Creating Application Load Balancer..."
ALB_ARN=$(aws elbv2 create-load-balancer \
    --name webserverloadbalancer \
    --subnets $SUBNET_PUBLIC_1 $SUBNET_PUBLIC_2 \
    --security-groups $SECURITY_GROUP_ID \
    --scheme internet-facing \
    --type application \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

# Create Target Group
echo "Creating Target Group..."
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name LabGroup \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --health-check-path "/index.php" \
    --health-check-interval-seconds 10 \
    --health-check-timeout-seconds 5 \
    --healthy-threshold-count 2 \
    --unhealthy-threshold-count 2 \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

# Create Listener for ALB
echo "Creating Listener for ALB..."
aws elbv2 create-listener \
    --load-balancer-arn $ALB_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN

# Create Launch Template
echo "Creating Launch Template..."
LAUNCH_TEMPLATE_ID=$(aws ec2 create-launch-template \
    --launch-template-name WebServerLaunchConfiguration \
    --version-description "Version1" \
    --launch-template-data "
{
    \"ImageId\": \"$AMI_ID\",
    \"InstanceType\": \"t3.micro\",
    \"SecurityGroupIds\": [\"$SECURITY_GROUP_ID\"],
    \"UserData\": \"$(base64 -w0 < $USER_DATA_FILE)\",
    \"TagSpecifications\": [
        {
            \"ResourceType\": \"instance\",
            \"Tags\": [
                {\"Key\": \"Name\", \"Value\": \"WebApp\"}
            ]
        }
    ]
}" --query 'LaunchTemplate.LaunchTemplateId' --output text)

# Create Auto Scaling Group
echo "Creating Auto Scaling Group..."
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name WebServersASGroup \
    --launch-template LaunchTemplateId=$LAUNCH_TEMPLATE_ID,Version=1 \
    --min-size 2 \
    --max-size 4 \
    --desired-capacity 2 \
    --vpc-zone-identifier "$SUBNET_PRIVATE_1,$SUBNET_PRIVATE_2" \
    --target-group-arns $TARGET_GROUP_ARN \
    --health-check-type ELB \
    --health-check-grace-period 300 \
    --tags Key=Name,Value=WebApp,PropagateAtLaunch=true

# Attach Target Tracking Scaling Policy
echo "Attaching Scaling Policy..."
aws autoscaling put-scaling-policy \
    --auto-scaling-group-name WebServersASGroup \
    --policy-name TargetTrackingPolicy \
    --policy-type TargetTrackingScaling \
    --target-tracking-configuration "
{
    \"PredefinedMetricSpecification\": {
        \"PredefinedMetricType\": \"ASGAverageCPUUtilization\"
    },
    \"TargetValue\": 40.0
}"

echo "Auto Scaling Environment Setup Complete!"
