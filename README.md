# DevContainer Examples Collection

A comprehensive collection of VS Code Dev Container examples demonstrating different technologies, frameworks, and development patterns for experimental development environments.

## Available Examples

### [Go Redis Microservice](./go-redis-app/)
A complete Go microservice with Redis cache layer demonstrating:
- Multi-container development with Docker Compose
- Go web API with Gin framework
- Redis integration for visit counting
- Hot reloading with Air
- VS Code Dev Container configuration
- Development helper scripts

**Quick Start:**
```bash
cd go-redis-app
./dev.sh start
curl http://localhost:8080/health
```

### [FullStack Next.js + NestJS + PostgreSQL](./fullstack-nextjs-nestjs/)
A complete full-stack development environment demonstrating:
- Multi-service architecture (Frontend, Backend, Database)
- Next.js 14 with App Router and Tailwind CSS
- NestJS API with TypeORM and PostgreSQL
- Cross-container networking and communication
- Hot reloading for both frontend and backend
- Comprehensive development helper scripts

**Quick Start:**
```bash
cd fullstack-nextjs-nestjs
./dev.sh start
# Frontend: http://localhost:3000
# Backend API: http://localhost:4000
```

### [Infrastructure-as-Code Terraform + AWS](./terraform-aws/)
A specialized environment for Infrastructure-as-Code development demonstrating:
- Terraform 1.6.6 with AWS provider
- AWS CLI v2 with secure credential mounting
- Python 3.11 with boto3 for AWS automation
- Security tools (Checkov, TFLint, Terraform Compliance)
- Complete CI/CD pipeline with GitHub Actions
- Production-ready infrastructure examples

**Quick Start:**
```bash
cd terraform-aws
# Open in VS Code Dev Container
# Configure AWS credentials: aws configure
# Initialize Terraform: ./dev.sh tf-init
```

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Technical Concepts Demonstrated

Each example demonstrates:

1. **Container Orchestration**: Multi-service development environments
2. **Service Communication**: Container networking via Docker networks
3. **Data Persistence**: Data persistence between container restarts
4. **Development Workflow**: Hot reloading and live development
5. **VS Code Integration**: Dev Container development experience
6. **Technology Patterns**: Implementation patterns for different tech stacks

## Getting Started

1. **Clone this repository**:
   ```bash
   git clone <your-repo-url>
   cd explore-devcontainers
   ```

2. **Choose an example**:
   ```bash
   cd go-redis-app  # or any other example
   ```

3. **Follow the example's README** for specific instructions

## Common Commands

Most examples include helper scripts for easy management:

```bash
# Start development environment
./dev.sh start

# Check status
./dev.sh status

# View logs
./dev.sh logs

# Run tests
./dev.sh test

# Stop environment
./dev.sh stop
```

## Repository Structure

```
explore-devcontainers/
├── go-redis-app/           # Go microservice with Redis
├── fullstack-nextjs-nestjs/ # FullStack Next.js + NestJS + PostgreSQL
├── terraform-aws/          # Infrastructure-as-Code Terraform + AWS
├── README.md               # This file
└── .gitignore             # Git ignore rules
```

## Contributing

To add a new example, include:

1. **Complete Dev Container setup** (`.devcontainer/` folder)
2. **Working application** with clear functionality
3. **Comprehensive README** with:
   - Quick start instructions
   - API documentation
   - Troubleshooting guide
4. **Development helper script** (`dev.sh`)
5. **Tests** to verify functionality

## Resources

- [VS Code Dev Containers Documentation](https://code.visualstudio.com/docs/remote/containers)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dev Container Specification](https://containers.dev/)

## Planned Examples

- Node.js + PostgreSQL + Redis
- Python + FastAPI + MongoDB
- React + TypeScript + Vite
- Rust + Actix + PostgreSQL
- Java + Spring Boot + MySQL
- PHP + Laravel + Redis
- Kubernetes + Helm + ArgoCD
- Machine Learning + Jupyter + TensorFlow

Each example is designed to be self-contained and demonstrate specific development patterns and technologies.
