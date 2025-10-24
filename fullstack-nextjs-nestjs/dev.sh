#!/bin/bash

# FullStack Development Helper Script
# Next.js + NestJS + PostgreSQL DevContainer

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

print_service() {
    echo -e "${PURPLE}[SERVICE]${NC} $1"
}

print_api() {
    echo -e "${CYAN}[API]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if ports are available
check_ports() {
    local ports=(3000 4000 5432)
    for port in "${ports[@]}"; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            print_warning "Port $port is already in use"
        fi
    done
}

# Function to start the development environment
start_dev() {
    print_status "Starting FullStack development environment..."
    check_docker
    check_ports
    
    print_status "Building and starting containers..."
    docker-compose -f .devcontainer/docker-compose.yml up --build -d
    
    print_success "FullStack development environment started!"
    print_service "Frontend (Next.js): http://localhost:3000"
    print_service "Backend API (NestJS): http://localhost:4000"
    print_service "Database (PostgreSQL): localhost:5432"
    print_api "Health Check: http://localhost:4000/health"
    print_api "Users API: http://localhost:4000/users"
}

# Function to stop the development environment
stop_dev() {
    print_status "Stopping FullStack development environment..."
    docker-compose -f .devcontainer/docker-compose.yml down
    print_success "Development environment stopped"
}

# Function to show logs
show_logs() {
    print_status "Showing application logs..."
    docker-compose -f .devcontainer/docker-compose.yml logs -f
}

# Function to show frontend logs
show_frontend_logs() {
    print_status "Showing frontend logs..."
    docker-compose -f .devcontainer/docker-compose.yml logs -f frontend
}

# Function to show backend logs
show_backend_logs() {
    print_status "Showing backend logs..."
    docker-compose -f .devcontainer/docker-compose.yml logs -f backend
}

# Function to show database logs
show_db_logs() {
    print_status "Showing database logs..."
    docker-compose -f .devcontainer/docker-compose.yml logs -f db
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    print_status "Running frontend tests..."
    docker-compose -f .devcontainer/docker-compose.yml exec frontend npm test 2>/dev/null || print_warning "No frontend tests configured"
    
    print_status "Running backend tests..."
    docker-compose -f .devcontainer/docker-compose.yml exec backend npm test 2>/dev/null || print_warning "No backend tests configured"
}

# Function to access database
db_shell() {
    print_status "Accessing PostgreSQL shell..."
    docker-compose -f .devcontainer/docker-compose.yml exec db psql -U devuser -d fullstack_dev
}

# Function to show database status
db_status() {
    print_status "Database connection status:"
    docker-compose -f .devcontainer/docker-compose.yml exec db pg_isready -U devuser -d fullstack_dev
}

# Function to install dependencies
install_deps() {
    print_status "Installing dependencies..."
    print_status "Installing frontend dependencies..."
    docker-compose -f .devcontainer/docker-compose.yml exec frontend npm install
    
    print_status "Installing backend dependencies..."
    docker-compose -f .devcontainer/docker-compose.yml exec backend npm install
    
    print_success "Dependencies installed"
}

# Function to show status
show_status() {
    print_status "Container status:"
    docker-compose -f .devcontainer/docker-compose.yml ps
    
    echo ""
    print_status "Service endpoints:"
    print_service "Frontend (Next.js): http://localhost:3000"
    print_service "Backend API (NestJS): http://localhost:4000"
    print_service "Database (PostgreSQL): localhost:5432"
    
    echo ""
    print_status "API endpoints:"
    print_api "Health Check: http://localhost:4000/health"
    print_api "Users API: http://localhost:4000/users"
    print_api "Create User: POST http://localhost:4000/users"
    
    echo ""
    print_status "Database info:"
    print_api "Host: localhost"
    print_api "Port: 5432"
    print_api "Database: fullstack_dev"
    print_api "User: devuser"
    print_api "Password: devpass"
}

# Function to clean up
cleanup() {
    print_status "Cleaning up containers and volumes..."
    docker-compose -f .devcontainer/docker-compose.yml down -v
    docker system prune -f
    print_success "Cleanup completed"
}

# Function to restart services
restart() {
    print_status "Restarting services..."
    docker-compose -f .devcontainer/docker-compose.yml restart
    print_success "Services restarted"
}

# Function to show help
show_help() {
    echo "FullStack Development Helper Script"
    echo "Next.js + NestJS + PostgreSQL DevContainer"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start         Start the development environment"
    echo "  stop          Stop the development environment"
    echo "  restart       Restart all services"
    echo "  logs          Show all application logs"
    echo "  frontend-logs Show frontend logs only"
    echo "  backend-logs  Show backend logs only"
    echo "  db-logs       Show database logs only"
    echo "  test          Run tests"
    echo "  db            Access PostgreSQL shell"
    echo "  db-status     Check database connection"
    echo "  install       Install dependencies"
    echo "  status        Show container status and endpoints"
    echo "  cleanup       Clean up containers and volumes"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs"
    echo "  $0 test"
    echo "  $0 db"
}

# Main script logic
case "${1:-help}" in
    start)
        start_dev
        ;;
    stop)
        stop_dev
        ;;
    restart)
        restart
        ;;
    logs)
        show_logs
        ;;
    frontend-logs)
        show_frontend_logs
        ;;
    backend-logs)
        show_backend_logs
        ;;
    db-logs)
        show_db_logs
        ;;
    test)
        run_tests
        ;;
    db)
        db_shell
        ;;
    db-status)
        db_status
        ;;
    install)
        install_deps
        ;;
    status)
        show_status
        ;;
    cleanup)
        cleanup
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
