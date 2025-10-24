# Infrastructure-as-Code DevContainer

A specialized VS Code Dev Container environment for Infrastructure-as-Code development using Terraform, AWS CLI, and Python (boto3). This environment provides a reproducible, secure, and cloud-ready setup for provisioning AWS resources via Terraform, compatible across local VS Code and GitHub Codespaces.

## Project Structure

```
terraform-aws/
├── .devcontainer/
│   ├── devcontainer.json          # VS Code Dev Container configuration
│   ├── Dockerfile                 # Container with Terraform, AWS CLI, Python
│   └── post-create.sh            # Post-creation setup script
├── terraform/                     # Terraform configuration files
│   ├── main.tf                   # Main Terraform configuration
│   ├── variables.tf              # Variable definitions
│   ├── terraform.tfvars.example  # Example variable values
│   └── user_data.sh              # EC2 user data script
├── python/                       # Python boto3 examples
│   ├── requirements.txt          # Python dependencies
│   ├── aws_infrastructure.py     # AWS resource management
│   └── terraform_state.py        # Terraform state management
├── examples/                     # Additional examples
├── dev.sh                        # Development helper script
└── README.md                     # This file
```

## Features

- **Terraform 1.6.6**: Latest stable version with plugin caching
- **AWS CLI v2**: Complete AWS command-line interface
- **Python 3.11**: With boto3, botocore, and development tools
- **Security Tools**: Checkov, TFLint, Terraform Compliance
- **VS Code Extensions**: Terraform, AWS Toolkit, Python, Docker
- **AWS Credentials**: Secure mounting from host system
- **Development Tools**: Git, GitHub CLI, Docker-in-Docker

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- AWS Account with appropriate permissions
- AWS credentials configured locally (`~/.aws/credentials` and `~/.aws/config`)

## Quick Start

### Method 1: Using VS Code Dev Containers (Recommended)

1. **Open the project in VS Code**:
   ```bash
   code terraform-aws
   ```

2. **Open in Dev Container**:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "Dev Containers: Reopen in Container"
   - Select the command and wait for the container to build

3. **The container will automatically**:
   - Install Terraform, AWS CLI, and Python with boto3
   - Mount your AWS credentials securely
   - Install VS Code extensions
   - Run post-create setup script

### Method 2: Using Development Script

```bash
# Navigate to the project
cd terraform-aws

# Check status and versions
./dev.sh status

# Setup AWS credentials (if not already done)
./dev.sh aws-setup

# Initialize Terraform
./dev.sh tf-init

# Plan infrastructure changes
./dev.sh tf-plan

# Apply changes
./dev.sh tf-apply
```

## AWS Credentials Security

### How AWS Credentials Are Securely Accessed

The DevContainer securely mounts your local AWS credentials into the container using bind mounts:

1. **Host Credentials**: Your AWS credentials stored in `~/.aws/` on your local machine
2. **Container Mount**: Credentials are mounted to `/home/devuser/.aws/` inside the container
3. **Environment Variables**: AWS CLI automatically detects credentials in the mounted location
4. **No Credential Storage**: Credentials are never stored in the container image

### Credential Mount Configuration

```json
"mounts": [
  "source=${localEnv:HOME}/.aws,target=/home/devuser/.aws,type=bind,consistency=cached"
]
```

### Security Benefits

- **No Hardcoded Credentials**: Credentials remain on your host system
- **Automatic Sync**: Changes to credentials on host are immediately available in container
- **Isolation**: Each container instance uses the same credentials as your host
- **Clean Containers**: No sensitive data persists in container images

## Terraform Configuration

### Sample Infrastructure

The included Terraform configuration demonstrates:

- **VPC Setup**: Custom VPC with public and private subnets
- **Security Groups**: Web server security group with appropriate rules
- **EC2 Instances**: Auto-scaling web servers with user data
- **S3 Bucket**: Static content storage with versioning and encryption
- **Outputs**: Resource information for integration

### Key Files

- `terraform/main.tf`: Main infrastructure configuration
- `terraform/variables.tf`: Variable definitions with validation
- `terraform/terraform.tfvars.example`: Example variable values
- `terraform/user_data.sh`: EC2 instance initialization script

### Usage

```bash
# Navigate to terraform directory
cd terraform

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit variables as needed
vim terraform.tfvars

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## Python boto3 Integration

### AWS Infrastructure Management

The Python examples demonstrate:

- **Resource Listing**: EC2 instances, S3 buckets, VPCs
- **Resource Creation**: S3 buckets, security groups
- **State Management**: Terraform state file manipulation
- **Account Information**: AWS account and user details

### Key Files

- `python/aws_infrastructure.py`: Comprehensive AWS resource management
- `python/terraform_state.py`: Terraform state file operations
- `python/requirements.txt`: Python dependencies

### Usage

```bash
# Navigate to python directory
cd python

# Install dependencies
pip install -r requirements.txt

# Run AWS infrastructure example
python aws_infrastructure.py

# Run Terraform state example
python terraform_state.py
```

## Development Helper Script

The `dev.sh` script provides convenient commands for common tasks:

### Available Commands

```bash
# Tool information
./dev.sh versions           # Show tool versions
./dev.sh status            # Show overall status

# AWS operations
./dev.sh aws-check         # Check AWS credentials and resources
./dev.sh aws-setup         # Setup AWS credentials

# Terraform operations
./dev.sh tf-init           # Initialize Terraform
./dev.sh tf-plan           # Plan Terraform changes
./dev.sh tf-apply          # Apply Terraform changes
./dev.sh tf-destroy        # Destroy Terraform resources
./dev.sh tf-state          # Show Terraform state
./dev.sh tf-validate       # Validate Terraform configuration
./dev.sh tf-format         # Format Terraform files

# Python operations
./dev.sh python-examples   # Run Python examples

# Help
./dev.sh help              # Show help message
```

### Example Workflow

```bash
# Check environment status
./dev.sh status

# Setup AWS credentials (if needed)
./dev.sh aws-setup

# Initialize and plan Terraform
./dev.sh tf-init
./dev.sh tf-plan

# Apply infrastructure changes
./dev.sh tf-apply

# Check AWS resources
./dev.sh aws-check

# Run Python examples
./dev.sh python-examples
```

## CI/CD Integration

### GitHub Actions Compatibility

This DevContainer configuration is fully compatible with GitHub Actions:

#### 1. Container Image Usage

```yaml
name: Terraform CI/CD
on: [push, pull_request]

jobs:
  terraform:
    runs-on: ubuntu-latest
    container:
      image: your-registry/terraform-aws-devcontainer:latest
      options: --user root
    steps:
      - uses: actions/checkout@v4
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      - name: Terraform Init
        run: terraform init
      - name: Terraform Plan
        run: terraform plan
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

#### 2. Dockerfile for CI/CD

```dockerfile
# Use the same base as DevContainer
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl unzip git ca-certificates gnupg lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install Python dependencies
RUN pip install boto3 botocore

# Set working directory
WORKDIR /workspace
```

## Best Practices

### Environment Reproducibility

1. **Version Pinning**: All tools use specific versions
   - Terraform: 1.6.6
   - AWS CLI: 2.13.30
   - Python: 3.11
   - boto3: 1.34.0

2. **Dependency Management**: 
   - Terraform: `required_version` and `required_providers`
   - Python: `requirements.txt` with pinned versions
   - System: Alpine packages with specific versions

3. **Configuration Management**:
   - Environment variables for configuration
   - Terraform variables with validation
   - AWS profiles for different environments

### Security Best Practices

1. **Credential Management**:
   - Never hardcode credentials in code
   - Use AWS IAM roles when possible
   - Rotate credentials regularly
   - Use least privilege principle

2. **Infrastructure Security**:
   - Enable VPC Flow Logs
   - Use security groups with minimal access
   - Enable S3 bucket versioning and encryption
   - Use CloudTrail for audit logging

3. **Code Security**:
   - Run security scans with Checkov
   - Validate Terraform with TFLint
   - Use Terraform Compliance for policy testing
   - Review and audit all changes

### Development Workflow

1. **Local Development**:
   ```bash
   # Start DevContainer
   code terraform-aws
   # (Reopen in Container)
   
   # Develop and test
   ./dev.sh tf-plan
   ./dev.sh python-examples
   ```

2. **Testing**:
   ```bash
   # Validate configuration
   ./dev.sh tf-validate
   
   # Security scanning
   checkov -d terraform/
   tflint terraform/
   ```

3. **Deployment**:
   ```bash
   # Plan changes
   ./dev.sh tf-plan
   
   # Apply changes
   ./dev.sh tf-apply
   
   # Verify deployment
   ./dev.sh aws-check
   ```

## Troubleshooting

### Common Issues

#### AWS Credentials Not Found
```bash
# Check credentials
./dev.sh aws-check

# Setup credentials
./dev.sh aws-setup

# Verify credentials
aws sts get-caller-identity
```

#### Terraform State Issues
```bash
# Reinitialize Terraform
./dev.sh tf-init

# Check state
./dev.sh tf-state

# Validate configuration
./dev.sh tf-validate
```

#### Python Dependencies
```bash
# Install dependencies
cd python
pip install -r requirements.txt

# Run examples
python aws_infrastructure.py
```

### Debug Mode

Enable debug logging for AWS CLI:
```bash
export AWS_CLI_AUTO_PROMPT=on-partial
export AWS_CLI_FILE_ENCODING=UTF-8
```

Enable Terraform debug logging:
```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log
```

## Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/remote/containers)
- [GitHub Codespaces](https://docs.github.com/en/codespaces)

## Contributing

To extend this DevContainer:

1. **Add new tools**: Update Dockerfile with additional packages
2. **Add VS Code extensions**: Update devcontainer.json extensions list
3. **Add Terraform modules**: Create new `.tf` files in terraform directory
4. **Add Python utilities**: Create new `.py` files in python directory
5. **Update helper script**: Add new commands to dev.sh

## License

This project is provided as-is for educational and development purposes. Use in production environments at your own risk.
