package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"testing"
)

type Post struct {
	ID    int    `json:"id"`
	Title string `json:"title"`
}

func TestFetchPosts(t *testing.T) {
	resp, err := http.Get("http://my-wordpress-loadbalancer-url/wp-json/wp/v2/posts")
	if err != nil {
		t.Fatalf("Failed to send GET request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		t.Errorf("Expected status code 200, got %d", resp.StatusCode)
	}

	var posts []Post
	if err := json.NewDecoder(resp.Body).Decode(&posts); err != nil {
		t.Fatalf("Failed to parse JSON response: %v", err)
	}

	fmt.Printf("Found %d posts.\n", len(posts))
}
