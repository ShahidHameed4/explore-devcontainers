#!/bin/bash

# Development helper script for Go Redis Microservice

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
    if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 8080 is already in use"
    fi
    
    if lsof -Pi :6379 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 6379 is already in use"
    fi
}

# Function to start the development environment
start_dev() {
    print_status "Starting development environment..."
    check_docker
    check_ports
    
    print_status "Building and starting containers..."
    docker-compose -f .devcontainer/docker-compose.yml up --build -d
    
    print_success "Development environment started!"
    print_status "API available at: http://localhost:8080"
    print_status "Redis available at: localhost:6379"
    print_status "Health check: http://localhost:8080/health"
}

# Function to stop the development environment
stop_dev() {
    print_status "Stopping development environment..."
    docker-compose -f .devcontainer/docker-compose.yml down
    print_success "Development environment stopped"
}

# Function to show logs
show_logs() {
    print_status "Showing application logs..."
    docker-compose -f .devcontainer/docker-compose.yml logs -f app
}

# Function to show Redis logs
show_redis_logs() {
    print_status "Showing Redis logs..."
    docker-compose -f .devcontainer/docker-compose.yml logs -f redis
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    docker-compose -f .devcontainer/docker-compose.yml exec app go test -v
}

# Function to access Redis CLI
redis_cli() {
    print_status "Accessing Redis CLI..."
    docker-compose -f .devcontainer/docker-compose.yml exec redis redis-cli
}

# Function to show status
show_status() {
    print_status "Container status:"
    docker-compose -f .devcontainer/docker-compose.yml ps
    
    echo ""
    print_status "API endpoints:"
    echo "  Health:    http://localhost:8080/health"
    echo "  Visit:     http://localhost:8080/visit/home"
    echo "  Visits:    http://localhost:8080/visits/home"
    echo "  Root:      http://localhost:8080/"
}

# Function to clean up
cleanup() {
    print_status "Cleaning up containers and volumes..."
    docker-compose -f .devcontainer/docker-compose.yml down -v
    docker system prune -f
    print_success "Cleanup completed"
}

# Function to show help
show_help() {
    echo "Go Redis Microservice Development Helper"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start the development environment"
    echo "  stop      Stop the development environment"
    echo "  logs      Show application logs"
    echo "  redis-logs Show Redis logs"
    echo "  test      Run tests"
    echo "  redis     Access Redis CLI"
    echo "  status    Show container status and endpoints"
    echo "  cleanup   Clean up containers and volumes"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs"
    echo "  $0 test"
}

# Main script logic
case "${1:-help}" in
    start)
        start_dev
        ;;
    stop)
        stop_dev
        ;;
    logs)
        show_logs
        ;;
    redis-logs)
        show_redis_logs
        ;;
    test)
        run_tests
        ;;
    redis)
        redis_cli
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
