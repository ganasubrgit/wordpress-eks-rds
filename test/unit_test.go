package main

import (
	"net/http"
	"testing"
)

func TestWordPressHomepage(t *testing.T) {
	resp, err := http.Get("http://my-wordpress-loadbalancer-url")
	if err != nil {
		t.Fatalf("Failed to send GET request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		t.Errorf("Expected status code 200, got %d", resp.StatusCode)
	}
}
