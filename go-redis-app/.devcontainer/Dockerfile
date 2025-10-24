# Use the official Go image as base
FROM golang:1.21-alpine

# Install additional tools for development
RUN apk add --no-cache \
    git \
    curl \
    bash \
    make \
    ca-certificates

# Set working directory
WORKDIR /workspace

# Install Air for hot reloading (using compatible version for Go 1.21)
RUN go install github.com/cosmtrek/air@v1.40.4

# Copy go mod files first for better caching
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Install dependencies and generate go.sum
RUN go mod tidy

# Expose port 8080
EXPOSE 8080

# Default command (can be overridden in docker-compose)
CMD ["air", "-c", ".air.toml"]
