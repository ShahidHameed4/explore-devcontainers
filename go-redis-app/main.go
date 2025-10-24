package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/redis/go-redis/v9"
)

// RedisClient wraps the Redis client
type RedisClient struct {
	client *redis.Client
}

// NewRedisClient creates a new Redis client
func NewRedisClient() *RedisClient {
	host := getEnv("REDIS_HOST", "localhost")
	port := getEnv("REDIS_PORT", "6379")
	
	rdb := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%s", host, port),
		Password: "", // no password
		DB:       0,  // default DB
	})

	return &RedisClient{client: rdb}
}

// IncrementVisitCount increments the visit count for a given page
func (r *RedisClient) IncrementVisitCount(ctx context.Context, page string) (int64, error) {
	key := fmt.Sprintf("visits:%s", page)
	return r.client.Incr(ctx, key).Result()
}

// GetVisitCount gets the current visit count for a given page
func (r *RedisClient) GetVisitCount(ctx context.Context, page string) (int64, error) {
	key := fmt.Sprintf("visits:%s", page)
	result := r.client.Get(ctx, key)
	if result.Err() == redis.Nil {
		return 0, nil
	}
	return result.Int64()
}

// Ping tests the Redis connection
func (r *RedisClient) Ping(ctx context.Context) error {
	return r.client.Ping(ctx).Err()
}

// VisitResponse represents the API response
type VisitResponse struct {
	Page      string `json:"page"`
	Visits    int64  `json:"visits"`
	Timestamp string `json:"timestamp"`
}

// HealthResponse represents the health check response
type HealthResponse struct {
	Status    string `json:"status"`
	Redis     string `json:"redis"`
	Timestamp string `json:"timestamp"`
}

func main() {
	// Initialize Redis client
	redisClient := NewRedisClient()
	ctx := context.Background()

	// Test Redis connection
	if err := redisClient.Ping(ctx); err != nil {
		log.Printf("Failed to connect to Redis: %v", err)
		log.Println("Make sure Redis is running and accessible")
	} else {
		log.Println("Successfully connected to Redis")
	}

	// Set up Gin router
	r := gin.Default()

	// Add CORS middleware
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type")
		
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		
		c.Next()
	})

	// Health check endpoint
	r.GET("/health", func(c *gin.Context) {
		redisStatus := "healthy"
		if err := redisClient.Ping(ctx); err != nil {
			redisStatus = "unhealthy"
		}

		response := HealthResponse{
			Status:    "healthy",
			Redis:     redisStatus,
			Timestamp: time.Now().Format(time.RFC3339),
		}

		c.JSON(http.StatusOK, response)
	})

	// Visit counter endpoint
	r.GET("/visit/:page", func(c *gin.Context) {
		page := c.Param("page")
		if page == "" {
			page = "home"
		}

		// Increment visit count
		visits, err := redisClient.IncrementVisitCount(ctx, page)
		if err != nil {
			log.Printf("Error incrementing visit count: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error": "Failed to increment visit count",
			})
			return
		}

		response := VisitResponse{
			Page:      page,
			Visits:    visits,
			Timestamp: time.Now().Format(time.RFC3339),
		}

		c.JSON(http.StatusOK, response)
	})

	// Get visit count without incrementing
	r.GET("/visits/:page", func(c *gin.Context) {
		page := c.Param("page")
		if page == "" {
			page = "home"
		}

		visits, err := redisClient.GetVisitCount(ctx, page)
		if err != nil {
			log.Printf("Error getting visit count: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error": "Failed to get visit count",
			})
			return
		}

		response := VisitResponse{
			Page:      page,
			Visits:    visits,
			Timestamp: time.Now().Format(time.RFC3339),
		}

		c.JSON(http.StatusOK, response)
	})

	// Root endpoint with basic info
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Go Redis Microservice",
			"version": "1.0.0",
			"endpoints": gin.H{
				"health": "/health",
				"visit":  "/visit/:page",
				"visits": "/visits/:page",
			},
		})
	})

	// Start server
	port := getEnv("PORT", "8080")
	log.Printf("Starting server on port %s", port)
	log.Printf("Health check: http://localhost:%s/health", port)
	log.Printf("Visit counter: http://localhost:%s/visit/home", port)
	
	if err := r.Run(":" + port); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}

// getEnv gets an environment variable with a fallback value
func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
