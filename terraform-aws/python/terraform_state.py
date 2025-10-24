#!/usr/bin/env python3
"""
Terraform State Management with boto3
This script demonstrates how to interact with Terraform state stored in S3
"""

import boto3
import json
import tempfile
import os
from typing import Dict, List, Optional
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class TerraformStateManager:
    """Manage Terraform state stored in S3"""
    
    def __init__(self, bucket_name: str, state_key: str, region: str = 'us-east-1'):
        """
        Initialize Terraform state manager
        
        Args:
            bucket_name: S3 bucket containing Terraform state
            state_key: S3 key for Terraform state file
            region: AWS region
        """
        self.bucket_name = bucket_name
        self.state_key = state_key
        self.region = region
        
        self.s3 = boto3.client('s3', region_name=region)
        logger.info(f"Initialized Terraform state manager for s3://{bucket_name}/{state_key}")
    
    def download_state(self) -> Optional[Dict]:
        """Download Terraform state from S3"""
        try:
            with tempfile.NamedTemporaryFile(mode='w+b', delete=False) as temp_file:
                self.s3.download_fileobj(self.bucket_name, self.state_key, temp_file)
                temp_file.seek(0)
                state_data = json.load(temp_file)
                os.unlink(temp_file.name)
                
                logger.info("Successfully downloaded Terraform state")
                return state_data
        except Exception as e:
            logger.error(f"Error downloading Terraform state: {e}")
            return None
    
    def upload_state(self, state_data: Dict) -> bool:
        """Upload Terraform state to S3"""
        try:
            with tempfile.NamedTemporaryFile(mode='w', delete=False) as temp_file:
                json.dump(state_data, temp_file, indent=2)
                temp_file.flush()
                
                self.s3.upload_file(temp_file.name, self.bucket_name, self.state_key)
                os.unlink(temp_file.name)
                
                logger.info("Successfully uploaded Terraform state")
                return True
        except Exception as e:
            logger.error(f"Error uploading Terraform state: {e}")
            return False
    
    def get_resources(self) -> List[Dict]:
        """Get all resources from Terraform state"""
        state_data = self.download_state()
        if not state_data:
            return []
        
        resources = []
        for resource in state_data.get('resources', []):
            for instance in resource.get('instances', []):
                resources.append({
                    'type': resource['type'],
                    'name': resource['name'],
                    'provider': resource['provider'],
                    'state': instance.get('attributes', {}),
                    'dependencies': resource.get('depends_on', [])
                })
        
        return resources
    
    def get_resource_by_type(self, resource_type: str) -> List[Dict]:
        """Get resources filtered by type"""
        all_resources = self.get_resources()
        return [r for r in all_resources if r['type'] == resource_type]
    
    def get_resource_by_name(self, resource_name: str) -> Optional[Dict]:
        """Get a specific resource by name"""
        all_resources = self.get_resources()
        for resource in all_resources:
            if resource['name'] == resource_name:
                return resource
        return None
    
    def list_outputs(self) -> Dict:
        """Get Terraform outputs from state"""
        state_data = self.download_state()
        if not state_data:
            return {}
        
        return state_data.get('outputs', {})


def main():
    """Main function to demonstrate Terraform state management"""
    print("Terraform State Management Demo")
    print("=" * 40)
    
    # Example usage (replace with your actual bucket and key)
    bucket_name = "your-terraform-state-bucket"
    state_key = "dev/terraform.tfstate"
    
    print(f"Note: This demo uses example bucket '{bucket_name}' and key '{state_key}'")
    print("Replace these with your actual Terraform state location")
    
    # Initialize state manager
    state_manager = TerraformStateManager(bucket_name, state_key)
    
    # Try to download state (will fail with example bucket)
    print("\n1. Attempting to download Terraform state...")
    state_data = state_manager.download_state()
    
    if state_data:
        print("   ✓ Successfully downloaded state")
        
        # Get resources
        print("\n2. Resources in state:")
        resources = state_manager.get_resources()
        if resources:
            for resource in resources:
                print(f"   {resource['type']}.{resource['name']}")
        else:
            print("   No resources found")
        
        # Get outputs
        print("\n3. Terraform outputs:")
        outputs = state_manager.list_outputs()
        if outputs:
            for name, output in outputs.items():
                print(f"   {name}: {output.get('value', 'N/A')}")
        else:
            print("   No outputs found")
    else:
        print("   ✗ Failed to download state (expected with example bucket)")
        print("   This is normal - replace bucket_name and state_key with real values")
    
    print("\n" + "=" * 40)
    print("Demo completed!")


if __name__ == "__main__":
    main()
