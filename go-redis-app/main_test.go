package main

import (
	"context"
	"testing"
	"time"

	"github.com/redis/go-redis/v9"
)

func TestRedisConnection(t *testing.T) {
	// Create Redis client
	rdb := redis.NewClient(&redis.Options{
		Addr:     "redis:6379",
		Password: "",
		DB:       0,
	})

	ctx := context.Background()

	// Test connection
	err := rdb.Ping(ctx).Err()
	if err != nil {
		t.Fatalf("Failed to connect to Redis: %v", err)
	}

	// Test basic operations
	testKey := "test:counter"
	testValue := int64(42)

	// Set a value
	err = rdb.Set(ctx, testKey, testValue, 0).Err()
	if err != nil {
		t.Fatalf("Failed to set value: %v", err)
	}

	// Get the value
	val, err := rdb.Get(ctx, testKey).Int64()
	if err != nil {
		t.Fatalf("Failed to get value: %v", err)
	}

	if val != testValue {
		t.Errorf("Expected %d, got %d", testValue, val)
	}

	// Increment the value
	newVal, err := rdb.Incr(ctx, testKey).Result()
	if err != nil {
		t.Fatalf("Failed to increment value: %v", err)
	}

	if newVal != testValue+1 {
		t.Errorf("Expected %d, got %d", testValue+1, newVal)
	}

	// Clean up
	rdb.Del(ctx, testKey)
}

func TestRedisClient(t *testing.T) {
	client := NewRedisClient()
	ctx := context.Background()

	// Test ping
	err := client.Ping(ctx)
	if err != nil {
		t.Fatalf("Failed to ping Redis: %v", err)
	}

	// Test visit counter
	page := "test-page"
	
	// Get initial count (should be 0)
	count, err := client.GetVisitCount(ctx, page)
	if err != nil {
		t.Fatalf("Failed to get visit count: %v", err)
	}
	if count != 0 {
		t.Errorf("Expected initial count to be 0, got %d", count)
	}

	// Increment count
	count, err = client.IncrementVisitCount(ctx, page)
	if err != nil {
		t.Fatalf("Failed to increment visit count: %v", err)
	}
	if count != 1 {
		t.Errorf("Expected count to be 1, got %d", count)
	}

	// Increment again
	count, err = client.IncrementVisitCount(ctx, page)
	if err != nil {
		t.Fatalf("Failed to increment visit count: %v", err)
	}
	if count != 2 {
		t.Errorf("Expected count to be 2, got %d", count)
	}

	// Clean up
	rdb := redis.NewClient(&redis.Options{
		Addr:     "redis:6379",
		Password: "",
		DB:       0,
	})
	rdb.Del(ctx, "visits:"+page)
}
