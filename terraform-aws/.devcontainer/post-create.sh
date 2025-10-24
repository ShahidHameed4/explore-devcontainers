#!/bin/bash

# Post-create script for Infrastructure-as-Code DevContainer
# Shows versions and sets up the environment

set -e

echo "=========================================="
echo "Infrastructure-as-Code DevContainer Setup"
echo "=========================================="

# Show versions
echo ""
echo "Installed Tools:"
echo "================"
echo "Terraform version:"
terraform version

echo ""
echo "AWS CLI version:"
aws --version

echo ""
echo "Python version:"
python --version

echo ""
echo "Python packages:"
pip list | grep -E "(boto3|botocore|terraform-compliance|checkov)"

echo ""
echo "Environment Setup:"
echo "=================="
echo "AWS Credentials: ${AWS_SHARED_CREDENTIALS_FILE}"
echo "AWS Config: ${AWS_CONFIG_FILE}"
echo "Terraform Plugin Cache: ${TF_PLUGIN_CACHE_DIR}"
echo "Working Directory: $(pwd)"

echo ""
echo "AWS Configuration Status:"
echo "========================"
if [ -f "${AWS_SHARED_CREDENTIALS_FILE}" ]; then
    echo "✓ AWS credentials file found"
    echo "Available profiles:"
    aws configure list-profiles 2>/dev/null || echo "No profiles configured"
else
    echo "⚠ AWS credentials file not found"
    echo "Please configure AWS credentials:"
    echo "  aws configure"
fi

echo ""
echo "Terraform Setup:"
echo "================"
if [ -d "terraform" ]; then
    echo "✓ Terraform directory found"
    cd terraform
    if [ -f "main.tf" ]; then
        echo "✓ Terraform configuration found"
        echo "Running terraform init..."
        terraform init -upgrade
    else
        echo "⚠ No main.tf found in terraform directory"
    fi
    cd ..
else
    echo "⚠ Terraform directory not found"
fi

echo ""
echo "Python Environment:"
echo "==================="
if [ -d "python" ]; then
    echo "✓ Python directory found"
    if [ -f "python/requirements.txt" ]; then
        echo "✓ requirements.txt found"
        echo "Installing Python dependencies..."
        pip install -r python/requirements.txt
    fi
else
    echo "⚠ Python directory not found"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Configure AWS credentials: aws configure"
echo "2. Navigate to terraform directory: cd terraform"
echo "3. Initialize Terraform: terraform init"
echo "4. Plan your infrastructure: terraform plan"
echo "5. Apply changes: terraform apply"
echo ""
echo "For Python development:"
echo "1. Navigate to python directory: cd python"
echo "2. Install dependencies: pip install -r requirements.txt"
echo "3. Run Python scripts: python example.py"
echo ""
