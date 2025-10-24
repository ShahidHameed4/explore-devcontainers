#!/bin/bash

# Infrastructure-as-Code Development Helper Script
# Terraform + AWS CLI + Python (boto3) DevContainer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_terraform() {
    echo -e "${PURPLE}[TERRAFORM]${NC} $1"
}

print_aws() {
    echo -e "${CYAN}[AWS]${NC} $1"
}

# Function to check AWS credentials
check_aws_credentials() {
    print_status "Checking AWS credentials..."
    
    if aws sts get-caller-identity >/dev/null 2>&1; then
        local account_id=$(aws sts get-caller-identity --query Account --output text)
        local user_arn=$(aws sts get-caller-identity --query Arn --output text)
        print_success "AWS credentials are valid"
        print_aws "Account ID: $account_id"
        print_aws "User: $user_arn"
        return 0
    else
        print_error "AWS credentials not configured or invalid"
        print_warning "Run 'aws configure' to set up credentials"
        return 1
    fi
}

# Function to show tool versions
show_versions() {
    print_status "Tool Versions:"
    echo "==============="
    echo "Terraform: $(terraform version -json | jq -r '.terraform_version')"
    echo "AWS CLI: $(aws --version | cut -d' ' -f1)"
    echo "Python: $(python --version)"
    echo "Python packages:"
    pip list | grep -E "(boto3|botocore)" | head -2
    echo ""
}

# Function to initialize Terraform
terraform_init() {
    print_terraform "Initializing Terraform..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    if [ ! -f "main.tf" ]; then
        print_error "main.tf not found in terraform directory"
        cd ..
        return 1
    fi
    
    terraform init -upgrade
    print_success "Terraform initialized successfully"
    cd ..
}

# Function to plan Terraform changes
terraform_plan() {
    print_terraform "Planning Terraform changes..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    if [ ! -f ".terraform/terraform.tfstate" ] && [ ! -f "terraform.tfstate" ]; then
        print_warning "Terraform not initialized. Running init first..."
        terraform init
    fi
    
    terraform plan -out=tfplan
    print_success "Terraform plan created: tfplan"
    cd ..
}

# Function to apply Terraform changes
terraform_apply() {
    print_terraform "Applying Terraform changes..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    if [ ! -f "tfplan" ]; then
        print_warning "No plan file found. Creating plan first..."
        terraform plan -out=tfplan
    fi
    
    terraform apply tfplan
    print_success "Terraform changes applied successfully"
    cd ..
}

# Function to destroy Terraform resources
terraform_destroy() {
    print_terraform "Destroying Terraform resources..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    print_warning "This will destroy all resources managed by Terraform!"
    read -p "Are you sure? (yes/no): " confirm
    
    if [ "$confirm" = "yes" ]; then
        terraform destroy -auto-approve
        print_success "Terraform resources destroyed"
    else
        print_status "Destroy cancelled"
    fi
    
    cd ..
}

# Function to show Terraform state
terraform_state() {
    print_terraform "Terraform state information..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    if [ -f "terraform.tfstate" ] || [ -f ".terraform/terraform.tfstate" ]; then
        echo "Resources:"
        terraform state list
        echo ""
        echo "Outputs:"
        terraform output
    else
        print_warning "No Terraform state found"
    fi
    
    cd ..
}

# Function to validate Terraform configuration
terraform_validate() {
    print_terraform "Validating Terraform configuration..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    terraform validate
    print_success "Terraform configuration is valid"
    
    cd ..
}

# Function to format Terraform files
terraform_format() {
    print_terraform "Formatting Terraform files..."
    
    if [ ! -d "terraform" ]; then
        print_error "Terraform directory not found"
        return 1
    fi
    
    cd terraform
    
    terraform fmt -recursive
    print_success "Terraform files formatted"
    
    cd ..
}

# Function to run Python examples
run_python_examples() {
    print_status "Running Python examples..."
    
    if [ ! -d "python" ]; then
        print_error "Python directory not found"
        return 1
    fi
    
    cd python
    
    if [ -f "requirements.txt" ]; then
        print_status "Installing Python dependencies..."
        pip install -r requirements.txt
    fi
    
    if [ -f "aws_infrastructure.py" ]; then
        print_status "Running AWS infrastructure example..."
        python aw_infrastructure.py
    fi
    
    if [ -f "terraform_state.py" ]; then
        print_status "Running Terraform state example..."
        python terraform_state.py
    fi
    
    cd ..
}

# Function to check AWS resources
check_aws_resources() {
    print_aws "Checking AWS resources..."
    
    if ! check_aws_credentials; then
        return 1
    fi
    
    echo "EC2 Instances:"
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' --output table
    
    echo ""
    echo "S3 Buckets:"
    aws s3 ls
    
    echo ""
    echo "VPCs:"
    aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock,State]' --output table
}

# Function to setup AWS credentials
setup_aws_credentials() {
    print_status "Setting up AWS credentials..."
    print_warning "This will prompt for AWS credentials"
    aws configure
}

# Function to show help
show_help() {
    echo "Infrastructure-as-Code Development Helper"
    echo "Terraform + AWS CLI + Python (boto3) DevContainer"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  versions           Show tool versions"
    echo "  aws-check          Check AWS credentials and resources"
    echo "  aws-setup          Setup AWS credentials"
    echo "  tf-init            Initialize Terraform"
    echo "  tf-plan            Plan Terraform changes"
    echo "  tf-apply           Apply Terraform changes"
    echo "  tf-destroy         Destroy Terraform resources"
    echo "  tf-state           Show Terraform state"
    echo "  tf-validate        Validate Terraform configuration"
    echo "  tf-format          Format Terraform files"
    echo "  python-examples    Run Python examples"
    echo "  status             Show overall status"
    echo "  help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 versions"
    echo "  $0 tf-init"
    echo "  $0 tf-plan"
    echo "  $0 aws-check"
}

# Function to show status
show_status() {
    print_status "Infrastructure-as-Code Development Environment Status"
    echo "=================================================="
    
    show_versions
    
    echo "AWS Configuration:"
    echo "=================="
    if check_aws_credentials; then
        echo "✓ AWS credentials configured"
    else
        echo "✗ AWS credentials not configured"
    fi
    
    echo ""
    echo "Terraform Configuration:"
    echo "========================"
    if [ -d "terraform" ] && [ -f "terraform/main.tf" ]; then
        echo "✓ Terraform configuration found"
        cd terraform
        if [ -f ".terraform/terraform.tfstate" ] || [ -f "terraform.tfstate" ]; then
            echo "✓ Terraform initialized"
        else
            echo "✗ Terraform not initialized"
        fi
        cd ..
    else
        echo "✗ Terraform configuration not found"
    fi
    
    echo ""
    echo "Python Environment:"
    echo "=================="
    if [ -d "python" ]; then
        echo "✓ Python directory found"
        if [ -f "python/requirements.txt" ]; then
            echo "✓ requirements.txt found"
        fi
    else
        echo "✗ Python directory not found"
    fi
}

# Main script logic
case "${1:-help}" in
    versions)
        show_versions
        ;;
    aws-check)
        check_aws_resources
        ;;
    aws-setup)
        setup_aws_credentials
        ;;
    tf-init)
        terraform_init
        ;;
    tf-plan)
        terraform_plan
        ;;
    tf-apply)
        terraform_apply
        ;;
    tf-destroy)
        terraform_destroy
        ;;
    tf-state)
        terraform_state
        ;;
    tf-validate)
        terraform_validate
        ;;
    tf-format)
        terraform_format
        ;;
    python-examples)
        run_python_examples
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
