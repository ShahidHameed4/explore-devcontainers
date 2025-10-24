# DevContainer Examples Collection

A comprehensive collection of VS Code Dev Container examples demonstrating different technologies, frameworks, and development patterns.

## 🚀 Available Examples

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

## 🛠️ Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## 📚 What You'll Learn

Each example demonstrates:

1. **Container Orchestration**: How to set up multi-service development environments
2. **Service Communication**: How containers communicate via Docker networks
3. **Data Persistence**: How to persist data between container restarts
4. **Development Workflow**: Hot reloading and live development
5. **VS Code Integration**: How Dev Containers enhance the development experience
6. **Technology Patterns**: Best practices for different tech stacks

## 🎯 Getting Started

1. **Clone this repository**:
   ```bash
   git clone <your-repo-url>
   cd devcontainer-examples
   ```

2. **Choose an example**:
   ```bash
   cd go-redis-app  # or any other example
   ```

3. **Follow the example's README** for specific instructions

## 🔧 Common Commands

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

## 📁 Repository Structure

```
devcontainer-examples/
├── go-redis-app/           # Go microservice with Redis
├── fullstack-nextjs-nestjs/ # FullStack Next.js + NestJS + PostgreSQL
├── README.md               # This file
└── .gitignore             # Git ignore rules
```

## 🤝 Contributing

Want to add a new example? Here's what to include:

1. **Complete Dev Container setup** (`.devcontainer/` folder)
2. **Working application** with clear functionality
3. **Comprehensive README** with:
   - Quick start instructions
   - API documentation
   - Troubleshooting guide
4. **Development helper script** (`dev.sh`)
5. **Tests** to verify functionality

## 📖 Learning Resources

- [VS Code Dev Containers Documentation](https://code.visualstudio.com/docs/remote/containers)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dev Container Specification](https://containers.dev/)

## 🎉 Examples Coming Soon

- Node.js + PostgreSQL + Redis
- Python + FastAPI + MongoDB
- React + TypeScript + Vite
- Rust + Actix + PostgreSQL
- Java + Spring Boot + MySQL
- PHP + Laravel + Redis

---

**Happy coding! 🚀**

Each example is designed to be self-contained and educational. Pick one that interests you and start exploring!
