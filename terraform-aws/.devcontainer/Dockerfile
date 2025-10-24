# Infrastructure-as-Code DevContainer
# Terraform + AWS CLI + Python (boto3)

FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TERRAFORM_VERSION=1.6.6
ENV AWS_CLI_VERSION=2.13.30
ENV TF_PLUGIN_CACHE_DIR=/tmp/.terraform.d/plugin-cache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y terraform=${TERRAFORM_VERSION}-1 \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install TFLint (Go binary)
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install Python dependencies
RUN pip install --no-cache-dir \
    boto3==1.34.0 \
    botocore==1.34.0 \
    awscli-local==0.22 \
    terraform-compliance==1.3.44 \
    checkov==3.1.0

# Create working directory
WORKDIR /workspace

# Create directories for AWS credentials and Terraform cache
RUN mkdir -p /root/.aws \
    && mkdir -p /tmp/.terraform.d/plugin-cache \
    && mkdir -p /workspace/terraform \
    && mkdir -p /workspace/python \
    && mkdir -p /workspace/examples

# Set up Terraform plugin cache
RUN terraform providers mirror /tmp/.terraform.d/plugin-cache || true

# Create a non-root user for security
RUN useradd -m -s /bin/bash devuser \
    && usermod -aG sudo devuser \
    && echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to non-root user
USER devuser
WORKDIR /home/devuser/workspace

# Create directories for the user
RUN mkdir -p /home/devuser/.aws \
    && mkdir -p /home/devuser/.terraform.d/plugin-cache \
    && mkdir -p /home/devuser/workspace/terraform \
    && mkdir -p /home/devuser/workspace/python \
    && mkdir -p /home/devuser/workspace/examples

# Set environment variables for the user
ENV TF_PLUGIN_CACHE_DIR=/home/devuser/.terraform.d/plugin-cache
ENV AWS_SHARED_CREDENTIALS_FILE=/home/devuser/.aws/credentials
ENV AWS_CONFIG_FILE=/home/devuser/.aws/config

# Copy post-create script
COPY --chown=devuser:devuser .devcontainer/post-create.sh /home/devuser/
RUN chmod +x /home/devuser/post-create.sh

# Default command
CMD ["/bin/bash"]
