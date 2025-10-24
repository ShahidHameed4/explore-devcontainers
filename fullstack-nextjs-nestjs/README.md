# FullStack Next.js + NestJS + PostgreSQL DevContainer

A complete full-stack development environment using VS Code Dev Containers that demonstrates a real-world team development setup with multiple services running inside containers and full cross-container networking.

## 🏗️ Project Structure

```
fullstack-nextjs-nestjs/
├── .devcontainer/
│   ├── devcontainer.json          # VS Code Dev Container configuration
│   ├── docker-compose.yml         # Multi-service orchestration
│   ├── Dockerfile.frontend        # Next.js container definition
│   └── Dockerfile.backend         # NestJS container definition
├── frontend/                      # Next.js React application
│   ├── app/                      # App Router structure
│   ├── package.json              # Frontend dependencies
│   ├── tailwind.config.js        # Tailwind CSS configuration
│   └── next.config.js            # Next.js configuration
├── backend/                       # NestJS API server
│   ├── src/                      # Source code
│   │   ├── users/                # Users module
│   │   ├── app.module.ts          # Main application module
│   │   └── main.ts               # Application entry point
│   └── package.json              # Backend dependencies
├── database/                      # Database initialization
│   └── init.sql                  # PostgreSQL setup script
├── dev.sh                        # Development helper script
└── README.md                     # This file
```

## 🚀 Features

- **Multi-Service Architecture**: Frontend, Backend, and Database in separate containers
- **Live Reload**: Hot reloading for both frontend and backend
- **Cross-Container Networking**: Services communicate via Docker networks
- **Database Persistence**: PostgreSQL data persists between container restarts
- **VS Code Integration**: Pre-configured with TypeScript, ESLint, Prettier, and database extensions
- **Development Tools**: Comprehensive helper script for easy management

## 📋 Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## ⚡ Quick Start

```bash
# Navigate to the project directory
cd fullstack-nextjs-nestjs

# Start the development environment
./dev.sh start

# Check status and endpoints
./dev.sh status

# Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:4000
# Database: localhost:5432
```

## 🛠️ How to Run

### Method 1: Using the Development Script (Recommended) ⭐

The `dev.sh` script provides the easiest way to manage the development environment:

```bash
# Start all services
./dev.sh start

# Check status and endpoints
./dev.sh status

# View logs
./dev.sh logs

# Run tests
./dev.sh test

# Access database
./dev.sh db

# Stop environment
./dev.sh stop
```

### Method 2: Using VS Code Dev Containers

1. **Open the project in VS Code**:
   ```bash
   code fullstack-nextjs-nestjs
   ```

2. **Open in Dev Container**:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "Dev Containers: Reopen in Container"
   - Select the command and wait for the container to build

3. **The container will automatically**:
   - Build all three services (frontend, backend, database)
   - Install dependencies for both Node.js applications
   - Start all services with hot reload
   - Forward ports 3000 (frontend), 4000 (backend), 5432 (database)

### Method 3: Using Docker Compose Directly

```bash
# Start all services
docker-compose -f .devcontainer/docker-compose.yml up --build

# Start in background
docker-compose -f .devcontainer/docker-compose.yml up --build -d

# Stop services
docker-compose -f .devcontainer/docker-compose.yml down
```

## 🔧 Service Architecture

### Frontend Service (Next.js)
- **Port**: 3000
- **Technology**: Next.js 14 with App Router
- **Styling**: Tailwind CSS
- **Features**: TypeScript, ESLint, Prettier
- **Hot Reload**: Automatic on file changes

### Backend Service (NestJS)
- **Port**: 4000
- **Technology**: NestJS with TypeScript
- **Database**: PostgreSQL with TypeORM
- **Features**: Validation, CORS, Health checks
- **Hot Reload**: Automatic on file changes

### Database Service (PostgreSQL)
- **Port**: 5432
- **Version**: PostgreSQL 16
- **Persistence**: Docker volume for data
- **Initialization**: Custom SQL scripts
- **Health Checks**: Built-in connection monitoring

## 🌐 API Endpoints

### Backend API (http://localhost:4000)

#### Health Check
```bash
curl http://localhost:4000/health
```
Response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00Z",
  "service": "NestJS Backend API",
  "version": "1.0.0"
}
```

#### Users API
```bash
# Get all users
curl http://localhost:4000/users

# Create a new user
curl -X POST http://localhost:4000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# Get user by ID
curl http://localhost:4000/users/1

# Delete user
curl -X DELETE http://localhost:4000/users/1
```

### Frontend Application (http://localhost:3000)
- **Home Page**: User management interface
- **Features**: Create users, view user list, real-time updates
- **Styling**: Modern UI with Tailwind CSS

## 🐳 Container Communication

### How Services Communicate

1. **Docker Compose Network**: All services run on the same `app-network`
2. **Service Discovery**: Services connect using container names as hostnames:
   - Frontend → Backend: `http://backend:4000`
   - Backend → Database: `db:5432`
3. **Environment Variables**: Connection details passed via environment variables
4. **Health Checks**: Database health monitoring ensures proper startup order

### Data Persistence

- **PostgreSQL Data**: Stored in Docker volume `postgres_data`
- **Application Code**: Mounted from host to containers for live editing
- **Dependencies**: Cached in containers for faster rebuilds

## 🔄 Development Workflow

### Using the Development Script (`dev.sh`)

```bash
# Quick start - build and run everything
./dev.sh start

# Check if everything is running properly
./dev.sh status

# View application logs in real-time
./dev.sh logs

# View specific service logs
./dev.sh frontend-logs
./dev.sh backend-logs
./dev.sh db-logs

# Run tests
./dev.sh test

# Access PostgreSQL shell
./dev.sh db

# Install dependencies
./dev.sh install

# Restart services
./dev.sh restart

# Stop everything
./dev.sh stop

# Clean up containers and volumes
./dev.sh cleanup
```

### Hot Reload Development

1. **Frontend Changes**: Edit files in `frontend/` directory
   - Next.js automatically reloads the browser
   - TypeScript compilation happens in real-time

2. **Backend Changes**: Edit files in `backend/src/` directory
   - NestJS automatically restarts the server
   - TypeORM synchronizes database schema changes

3. **Database Changes**: Modify `database/init.sql`
   - Restart containers to apply changes
   - Use `./dev.sh restart` for quick restart

### Adding New Features

1. **Frontend**: Add new pages/components in `frontend/app/`
2. **Backend**: Create new modules in `backend/src/`
3. **Database**: Add new entities and update TypeORM configuration
4. **API Integration**: Update frontend to call new backend endpoints

## 🧪 Testing

### Running Tests

```bash
# Run all tests
./dev.sh test

# Run frontend tests (if configured)
docker-compose -f .devcontainer/docker-compose.yml exec frontend npm test

# Run backend tests
docker-compose -f .devcontainer/docker-compose.yml exec backend npm test
```

### Manual Testing

1. **Frontend**: Visit http://localhost:3000
2. **Backend API**: Test endpoints with curl or Postman
3. **Database**: Connect using `./dev.sh db`

## 🚨 Troubleshooting

### Quick Diagnostics with dev.sh

First, always check the status:
```bash
./dev.sh status
```

This will show you:
- Container status
- Service endpoints
- Port information
- Database connection details

### Common Issues

#### Services Won't Start
1. **Check Docker**: `./dev.sh start` will verify Docker is running
2. **Check ports**: The script will warn if ports 3000/4000/5432 are in use
3. **Clean rebuild**: `./dev.sh cleanup && ./dev.sh start`

#### Database Connection Issues
1. **Check database logs**: `./dev.sh db-logs`
2. **Test connection**: `./dev.sh db-status`
3. **Access database**: `./dev.sh db`

#### Frontend/Backend Communication Issues
1. **Check backend logs**: `./dev.sh backend-logs`
2. **Verify API endpoints**: `curl http://localhost:4000/health`
3. **Check environment variables**: Ensure `NEXT_PUBLIC_API_URL` is set correctly

#### Hot Reload Not Working
1. **Check logs**: `./dev.sh logs` to see service output
2. **Restart services**: `./dev.sh restart`
3. **Verify file changes**: Make a small change and save

### Common Solutions
- **Port conflicts**: Stop other services using ports 3000/4000/5432
- **Docker issues**: Restart Docker Desktop
- **Permission issues**: Ensure `dev.sh` is executable: `chmod +x dev.sh`
- **Clean slate**: `./dev.sh cleanup` removes all containers and volumes

## 🔧 Configuration Files Explained

### `.devcontainer/devcontainer.json`
- Configures VS Code with TypeScript, ESLint, Prettier, and database extensions
- Sets up port forwarding (3000, 4000, 5432)
- Defines post-create commands for dependency installation
- Configures development settings and workspace mounting

### `.devcontainer/docker-compose.yml`
- Defines three services: `frontend`, `backend`, and `db`
- Sets up networking between containers
- Configures volume mounts and port mappings
- Defines environment variables for service communication
- Includes health checks for proper startup order

### `.devcontainer/Dockerfile.frontend` & `.devcontainer/Dockerfile.backend`
- Both based on `node:20-alpine`
- Install development tools (git, curl, bash)
- Set up workspace directories
- Configure for hot reloading

## 📚 Learning Outcomes

This project demonstrates:

1. **Multi-Service Development**: How to orchestrate frontend, backend, and database services
2. **Service Communication**: How containers communicate via Docker networks
3. **Data Persistence**: How to persist database data between container restarts
4. **Development Workflow**: Hot reloading and live development across multiple services
5. **VS Code Integration**: How Dev Containers enhance full-stack development
6. **Modern Web Stack**: Next.js, NestJS, PostgreSQL, and TypeScript integration
7. **Container Orchestration**: Docker Compose for complex multi-service applications

## 🔗 Useful Commands

### Using dev.sh (Recommended)
```bash
# Start development environment
./dev.sh start

# Check status and endpoints
./dev.sh status

# View application logs
./dev.sh logs

# View specific service logs
./dev.sh frontend-logs
./dev.sh backend-logs
./dev.sh db-logs

# Run tests
./dev.sh test

# Access database
./dev.sh db

# Install dependencies
./dev.sh install

# Restart services
./dev.sh restart

# Stop environment
./dev.sh stop

# Clean up everything
./dev.sh cleanup
```

### Direct Docker Commands (Advanced)
```bash
# View running containers
docker ps

# View container logs
docker logs fullstack-nextjs-nestjs-frontend-1
docker logs fullstack-nextjs-nestjs-backend-1
docker logs fullstack-nextjs-nestjs-db-1

# Access database shell
docker exec -it fullstack-nextjs-nestjs-db-1 psql -U devuser -d fullstack_dev

# Access frontend container shell
docker exec -it fullstack-nextjs-nestjs-frontend-1 sh

# Access backend container shell
docker exec -it fullstack-nextjs-nestjs-backend-1 sh

# Stop all services
docker-compose -f .devcontainer/docker-compose.yml down

# Stop and remove volumes
docker-compose -f .devcontainer/docker-compose.yml down -v
```

## 🎯 Extending to GitHub Codespaces

This DevContainer configuration is fully compatible with GitHub Codespaces:

### 1. Push to GitHub
```bash
git add .
git commit -m "Add FullStack DevContainer example"
git push origin main
```

### 2. Create Codespace
- Go to your GitHub repository
- Click "Code" → "Codespaces" → "Create codespace"
- Select the repository and branch

### 3. Codespace Benefits
- **Cloud Development**: No local Docker installation required
- **Consistent Environment**: Same setup across all team members
- **Pre-configured**: All extensions and settings ready
- **Port Forwarding**: Automatic port forwarding for web services
- **Database Access**: PostgreSQL accessible via forwarded ports

### 4. Codespace-Specific Features
- **Port Visibility**: Set ports to "Public" for sharing
- **Environment Variables**: Configure in Codespace settings
- **Extensions**: Automatically installed from devcontainer.json
- **Terminal**: Full Linux environment with all tools

## 🎉 Next Steps

- Add authentication with JWT
- Implement user roles and permissions
- Add file upload functionality
- Set up Redis for caching
- Add comprehensive testing suite
- Implement CI/CD pipeline
- Add monitoring and logging
- Create production deployment configuration

---

**Happy coding! 🚀**

This full-stack DevContainer setup provides a complete development environment that mirrors real-world team development scenarios. Perfect for learning modern web development patterns and containerization!
