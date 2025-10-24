#!/bin/bash

# User data script for EC2 instances
# This script runs when the instance starts

set -e

# Update system
yum update -y

# Install basic tools
yum install -y \
    htop \
    vim \
    git \
    curl \
    wget \
    unzip \
    jq

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create a simple web page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${project_name} - Infrastructure as Code</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .header { background: #0073e6; color: white; padding: 20px; border-radius: 5px; }
        .content { margin: 20px 0; }
        .info { background: #f0f0f0; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${project_name}</h1>
            <p>Infrastructure as Code with Terraform</p>
        </div>
        <div class="content">
            <h2>Instance Information</h2>
            <div class="info">
                <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
                <p><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>
                <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
                <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
                <p><strong>Launch Time:</strong> $(date)</p>
            </div>
            <h2>Tools Installed</h2>
            <ul>
                <li>AWS CLI v2</li>
                <li>Docker</li>
                <li>Docker Compose</li>
                <li>Git, curl, wget, jq</li>
            </ul>
            <h2>Next Steps</h2>
            <p>This instance was created using Terraform in a DevContainer environment. You can:</p>
            <ul>
                <li>SSH into this instance to explore</li>
                <li>Deploy applications using Docker</li>
                <li>Use AWS CLI to manage resources</li>
                <li>Modify the Terraform configuration and reapply</li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF

# Start Apache web server
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Create a status file
echo "Instance setup completed at $(date)" > /var/www/html/status.txt

# Log completion
echo "User data script completed successfully" >> /var/log/user-data.log
