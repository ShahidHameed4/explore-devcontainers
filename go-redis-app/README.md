# Go Redis Microservice - Dev Container Project

This project demonstrates a complete VS Code Dev Container setup with a Go microservice that uses Redis as a cache layer. It showcases multi-container development using Docker Compose.

## ⚡ Quick Start

```bash
# Clone and navigate to the project
cd go-redis-app

# Start the development environment
./dev.sh start

# Check status and endpoints
./dev.sh status

# Test the API
curl http://localhost:8080/health
curl http://localhost:8080/visit/home

# Stop when done
./dev.sh stop
```

That's it! The `dev.sh` script handles everything for you. 🚀

## 🏗️ Project Structure

```
go-redis-app/
├── .devcontainer/
│   ├── devcontainer.json      # VS Code Dev Container configuration
│   ├── docker-compose.yml     # Multi-container setup
│   └── Dockerfile            # Go service container definition
├── main.go                   # Main Go application
├── main_test.go             # Unit tests
├── go.mod                   # Go module dependencies
├── go.sum                   # Go module checksums
├── .air.toml               # Hot reload configuration
└── README.md               # This file
```

## 🚀 Features

- **Multi-container Development**: Go service + Redis cache
- **Hot Reload**: Automatic code reloading with Air
- **Port Forwarding**: Automatic port forwarding for API (8080) and Redis (6379)
- **VS Code Integration**: Pre-configured with Go extensions and settings
- **Redis Persistence**: Data persists between container restarts
- **Health Checks**: Built-in health monitoring endpoints

## 📋 Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## 🛠️ How to Run

### Method 1: Using the Development Script (Recommended) ⭐

The `dev.sh` script provides the easiest way to manage the development environment:

1. **Navigate to the project directory**:
   ```bash
   cd go-redis-app
   ```

2. **Start the development environment**:
   ```bash
   ./dev.sh start
   ```
   This will:
   - Check Docker is running
   - Verify ports are available
   - Build and start both containers
   - Show you the API endpoints

3. **Check status and endpoints**:
   ```bash
   ./dev.sh status
   ```

4. **View logs**:
   ```bash
   ./dev.sh logs
   ```

5. **Run tests**:
   ```bash
   ./dev.sh test
   ```

6. **Stop the environment**:
   ```bash
   ./dev.sh stop
   ```

### Method 2: Using VS Code Dev Containers

1. **Open the project in VS Code**:
   ```bash
   code /path/to/go-redis-app
   ```

2. **Open in Dev Container**:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "Dev Containers: Reopen in Container"
   - Select the command and wait for the container to build

3. **The container will automatically**:
   - Build the Go service and Redis containers
   - Install Go dependencies (`go mod tidy`)
   - Start the application with hot reload
   - Forward ports 8080 (API) and 6379 (Redis)

### Method 3: Using Docker Compose Directly

1. **Navigate to the project directory**:
   ```bash
   cd go-redis-app
   ```

2. **Start the services**:
   ```bash
   docker-compose -f .devcontainer/docker-compose.yml up --build
   ```

3. **Access the application**:
   - API: http://localhost:8080
   - Redis: localhost:6379

## 🔧 API Endpoints

Once the container is running, you can test the following endpoints:

### Health Check
```bash
curl http://localhost:8080/health
```
Response:
```json
{
  "status": "healthy",
  "redis": "healthy",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### Visit Counter (Increment)
```bash
curl http://localhost:8080/visit/home
```
Response:
```json
{
  "page": "home",
  "visits": 1,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### Get Visit Count (Read Only)
```bash
curl http://localhost:8080/visits/home
```
Response:
```json
{
  "page": "home",
  "visits": 5,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### Root Endpoint
```bash
curl http://localhost:8080/
```
Response:
```json
{
  "message": "Go Redis Microservice",
  "version": "1.0.0",
  "endpoints": {
    "health": "/health",
    "visit": "/visit/:page",
    "visits": "/visits/:page"
  }
}
```

## 🧪 Running Tests

Inside the Dev Container, run:

```bash
# Run all tests
go test -v

# Run tests with coverage
go test -v -cover

# Run specific test
go test -v -run TestRedisConnection
```

## 🔄 Development Workflow

### Using the Development Script (`dev.sh`)

The `dev.sh` script is your main tool for managing the development environment:

```bash
# Quick start - build and run everything
./dev.sh start

# Check if everything is running properly
./dev.sh status

# View application logs in real-time
./dev.sh logs

# Run tests
./dev.sh test

# Access Redis CLI
./dev.sh redis

# Stop everything
./dev.sh stop

# Clean up containers and volumes
./dev.sh cleanup

# Show help
./dev.sh help
```

### Hot Reload
The application uses [Air](https://github.com/cosmtrek/air) for hot reloading. Any changes to `.go` files will automatically restart the server.

### Making Changes
1. Edit any Go file in the project
2. Save the file (`Ctrl+S`)
3. Air will automatically detect changes and restart the server
4. Test your changes via the API endpoints
5. Use `./dev.sh status` to verify everything is working

### Adding Dependencies
```bash
# Add a new dependency
go get github.com/example/package

# Update go.mod and go.sum
go mod tidy
```

## 🐳 Container Communication

### How Containers Communicate

1. **Docker Compose Network**: Both containers run on the same `app-network`
2. **Service Discovery**: The Go service connects to Redis using the hostname `redis`
3. **Environment Variables**: Redis connection details are passed via environment variables:
   - `REDIS_HOST=redis`
   - `REDIS_PORT=6379`

### Data Persistence

- **Redis Data**: Stored in a Docker volume `redis-data`
- **Application Code**: Mounted from host to `/workspace` in the container
- **Dependencies**: Installed during container build and cached

## 🔧 Configuration Files Explained

### `.devcontainer/devcontainer.json`
- Configures VS Code extensions (Go, JSON, YAML)
- Sets up port forwarding (8080, 6379)
- Defines post-create commands
- Configures Go development settings

### `.devcontainer/docker-compose.yml`
- Defines two services: `app` (Go) and `redis`
- Sets up networking between containers
- Configures volume mounts and port mappings
- Defines environment variables

### `.devcontainer/Dockerfile`
- Based on `golang:1.21-alpine`
- Installs development tools (git, curl, bash)
- Installs Air for hot reloading
- Sets up the workspace directory

### `.air.toml`
- Configures Air hot reloading
- Defines build commands and file watching
- Sets up logging and color output

## 🚨 Troubleshooting

### Quick Diagnostics with dev.sh

First, always check the status:
```bash
./dev.sh status
```

This will show you:
- Container status
- Available endpoints
- Port information

### Container Won't Start
1. **Check Docker**: `./dev.sh start` will verify Docker is running
2. **Check ports**: The script will warn if ports 8080/6379 are in use
3. **Clean rebuild**: `./dev.sh cleanup && ./dev.sh start`

### Redis Connection Issues
1. **Check Redis logs**: `./dev.sh redis-logs`
2. **Access Redis CLI**: `./dev.sh redis`
3. **Test connection**: In Redis CLI, run `ping`

### Go Dependencies Issues
1. **Restart containers**: `./dev.sh stop && ./dev.sh start`
2. **Check logs**: `./dev.sh logs` for build errors
3. **Run tests**: `./dev.sh test` to verify functionality

### Hot Reload Not Working
1. **Check logs**: `./dev.sh logs` to see Air output
2. **Restart**: `./dev.sh stop && ./dev.sh start`
3. **Verify file changes**: Make a small change and save

### Common Solutions
- **Port conflicts**: Stop other services using ports 8080/6379
- **Docker issues**: Restart Docker Desktop
- **Permission issues**: Ensure `dev.sh` is executable: `chmod +x dev.sh`
- **Clean slate**: `./dev.sh cleanup` removes all containers and volumes

## 📚 Learning Outcomes

This project demonstrates:

1. **Multi-container Development**: How to orchestrate multiple services
2. **Service Communication**: How containers communicate via networks
3. **Data Persistence**: How to persist data between container restarts
4. **Development Workflow**: Hot reloading and live development
5. **VS Code Integration**: How Dev Containers enhance the development experience
6. **Go + Redis Integration**: Practical microservice patterns

## 🔗 Useful Commands

### Using dev.sh (Recommended)
```bash
# Start development environment
./dev.sh start

# Check status and endpoints
./dev.sh status

# View application logs
./dev.sh logs

# View Redis logs
./dev.sh redis-logs

# Run tests
./dev.sh test

# Access Redis CLI
./dev.sh redis

# Stop environment
./dev.sh stop

# Clean up everything
./dev.sh cleanup

# Show help
./dev.sh help
```

### Direct Docker Commands (Advanced)
```bash
# View running containers
docker ps

# View container logs
docker logs devcontainer-app-1
docker logs devcontainer-redis-1

# Access Redis CLI
docker exec -it devcontainer-redis-1 redis-cli

# Access Go container shell
docker exec -it devcontainer-app-1 sh

# Stop all services
docker-compose -f .devcontainer/docker-compose.yml down

# Stop and remove volumes
docker-compose -f .devcontainer/docker-compose.yml down -v
```

## 🎯 Next Steps

- Add more API endpoints
- Implement authentication
- Add database integration (PostgreSQL)
- Set up monitoring and logging
- Add CI/CD pipeline
- Implement graceful shutdown
- Add rate limiting
- Create API documentation with Swagger

---

**Happy coding! 🚀**
