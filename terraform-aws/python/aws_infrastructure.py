#!/usr/bin/env python3
"""
AWS Infrastructure Management with boto3
This script demonstrates common AWS operations using boto3
"""

import boto3
import json
import time
from datetime import datetime
from typing import Dict, List, Optional
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class AWSInfrastructureManager:
    """AWS Infrastructure Management class using boto3"""
    
    def __init__(self, region: str = 'us-east-1', profile: Optional[str] = None):
        """
        Initialize AWS clients
        
        Args:
            region: AWS region
            profile: AWS profile name (optional)
        """
        self.region = region
        self.session = boto3.Session(profile_name=profile) if profile else boto3.Session()
        
        # Initialize AWS clients
        self.ec2 = self.session.client('ec2', region_name=region)
        self.s3 = self.session.client('s3', region_name=region)
        self.iam = self.session.client('iam', region_name=region)
        self.cloudformation = self.session.client('cloudformation', region_name=region)
        self.sts = self.session.client('sts', region_name=region)
        
        logger.info(f"Initialized AWS clients for region: {region}")
    
    def get_account_info(self) -> Dict:
        """Get AWS account information"""
        try:
            response = self.sts.get_caller_identity()
            return {
                'account_id': response['Account'],
                'user_id': response['UserId'],
                'arn': response['Arn']
            }
        except Exception as e:
            logger.error(f"Error getting account info: {e}")
            return {}
    
    def list_ec2_instances(self) -> List[Dict]:
        """List all EC2 instances"""
        try:
            response = self.ec2.describe_instances()
            instances = []
            
            for reservation in response['Reservations']:
                for instance in reservation['Instances']:
                    instances.append({
                        'instance_id': instance['InstanceId'],
                        'instance_type': instance['InstanceType'],
                        'state': instance['State']['Name'],
                        'public_ip': instance.get('PublicIpAddress', 'N/A'),
                        'private_ip': instance.get('PrivateIpAddress', 'N/A'),
                        'launch_time': instance['LaunchTime'].strftime('%Y-%m-%d %H:%M:%S'),
                        'tags': {tag['Key']: tag['Value'] for tag in instance.get('Tags', [])}
                    })
            
            return instances
        except Exception as e:
            logger.error(f"Error listing EC2 instances: {e}")
            return []
    
    def list_s3_buckets(self) -> List[Dict]:
        """List all S3 buckets"""
        try:
            response = self.s3.list_buckets()
            buckets = []
            
            for bucket in response['Buckets']:
                # Get bucket location
                try:
                    location_response = self.s3.get_bucket_location(Bucket=bucket['Name'])
                    region = location_response.get('LocationConstraint', 'us-east-1')
                except:
                    region = 'unknown'
                
                buckets.append({
                    'name': bucket['Name'],
                    'creation_date': bucket['CreationDate'].strftime('%Y-%m-%d %H:%M:%S'),
                    'region': region
                })
            
            return buckets
        except Exception as e:
            logger.error(f"Error listing S3 buckets: {e}")
            return []
    
    def create_s3_bucket(self, bucket_name: str, region: Optional[str] = None) -> bool:
        """Create an S3 bucket"""
        try:
            region = region or self.region
            
            if region == 'us-east-1':
                # us-east-1 doesn't need LocationConstraint
                self.s3.create_bucket(Bucket=bucket_name)
            else:
                self.s3.create_bucket(
                    Bucket=bucket_name,
                    CreateBucketConfiguration={'LocationConstraint': region}
                )
            
            logger.info(f"Created S3 bucket: {bucket_name}")
            return True
        except Exception as e:
            logger.error(f"Error creating S3 bucket {bucket_name}: {e}")
            return False
    
    def upload_file_to_s3(self, file_path: str, bucket_name: str, key: str) -> bool:
        """Upload a file to S3"""
        try:
            self.s3.upload_file(file_path, bucket_name, key)
            logger.info(f"Uploaded {file_path} to s3://{bucket_name}/{key}")
            return True
        except Exception as e:
            logger.error(f"Error uploading file to S3: {e}")
            return False
    
    def list_cloudformation_stacks(self) -> List[Dict]:
        """List CloudFormation stacks"""
        try:
            response = self.cloudformation.list_stacks(StackStatusFilter=['CREATE_COMPLETE', 'UPDATE_COMPLETE'])
            stacks = []
            
            for stack in response['StackSummaries']:
                stacks.append({
                    'stack_name': stack['StackName'],
                    'stack_status': stack['StackStatus'],
                    'creation_time': stack['CreationTime'].strftime('%Y-%m-%d %H:%M:%S'),
                    'description': stack.get('StackStatusReason', 'N/A')
                })
            
            return stacks
        except Exception as e:
            logger.error(f"Error listing CloudFormation stacks: {e}")
            return []
    
    def get_vpc_info(self) -> List[Dict]:
        """Get VPC information"""
        try:
            response = self.ec2.describe_vpcs()
            vpcs = []
            
            for vpc in response['Vpcs']:
                vpcs.append({
                    'vpc_id': vpc['VpcId'],
                    'cidr_block': vpc['CidrBlock'],
                    'state': vpc['State'],
                    'is_default': vpc['IsDefault'],
                    'tags': {tag['Key']: tag['Value'] for tag in vpc.get('Tags', [])}
                })
            
            return vpcs
        except Exception as e:
            logger.error(f"Error getting VPC info: {e}")
            return []
    
    def create_security_group(self, group_name: str, description: str, vpc_id: str) -> Optional[str]:
        """Create a security group"""
        try:
            response = self.ec2.create_security_group(
                GroupName=group_name,
                Description=description,
                VpcId=vpc_id
            )
            
            security_group_id = response['GroupId']
            logger.info(f"Created security group: {security_group_id}")
            return security_group_id
        except Exception as e:
            logger.error(f"Error creating security group: {e}")
            return None


def main():
    """Main function to demonstrate AWS operations"""
    print("AWS Infrastructure Management Demo")
    print("=" * 40)
    
    # Initialize AWS manager
    aws_manager = AWSInfrastructureManager()
    
    # Get account information
    print("\n1. Account Information:")
    account_info = aws_manager.get_account_info()
    if account_info:
        print(f"   Account ID: {account_info['account_id']}")
        print(f"   User ID: {account_info['user_id']}")
        print(f"   ARN: {account_info['arn']}")
    
    # List EC2 instances
    print("\n2. EC2 Instances:")
    instances = aws_manager.list_ec2_instances()
    if instances:
        for instance in instances:
            print(f"   {instance['instance_id']} ({instance['instance_type']}) - {instance['state']}")
            print(f"     Public IP: {instance['public_ip']}, Private IP: {instance['private_ip']}")
    else:
        print("   No EC2 instances found")
    
    # List S3 buckets
    print("\n3. S3 Buckets:")
    buckets = aws_manager.list_s3_buckets()
    if buckets:
        for bucket in buckets:
            print(f"   {bucket['name']} (Region: {bucket['region']})")
    else:
        print("   No S3 buckets found")
    
    # List CloudFormation stacks
    print("\n4. CloudFormation Stacks:")
    stacks = aws_manager.list_cloudformation_stacks()
    if stacks:
        for stack in stacks:
            print(f"   {stack['stack_name']} - {stack['stack_status']}")
    else:
        print("   No CloudFormation stacks found")
    
    # Get VPC information
    print("\n5. VPCs:")
    vpcs = aws_manager.get_vpc_info()
    if vpcs:
        for vpc in vpcs:
            print(f"   {vpc['vpc_id']} ({vpc['cidr_block']}) - {vpc['state']}")
            if vpc['is_default']:
                print("     [Default VPC]")
    else:
        print("   No VPCs found")
    
    print("\n" + "=" * 40)
    print("Demo completed successfully!")


if __name__ == "__main__":
    main()
