package main

import (
	"log"
	"net/http"
	"testing"
)

func TestWordPressHealthCheck(t *testing.T) {
	url := "http://my-wordpress-loadbalancer-url"
	log.Printf("Starting health check for: %s", url)

	resp, err := http.Get(url)
	if err != nil {
		log.Fatalf("Failed to connect to WordPress: %v", err)
	}
	defer resp.Body.Close()

	log.Printf("Received HTTP status: %d", resp.StatusCode)
	if resp.StatusCode != http.StatusOK {
		t.Errorf("Expected status code 200, got %d", resp.StatusCode)
	}
}
