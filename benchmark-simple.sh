#!/bin/bash

# Simplified benchmark script that tests one framework at a time
# Usage: ./benchmark-simple.sh [framework-name] [port]

set -e

FRAMEWORK=$1
PORT=$2

if [ -z "$FRAMEWORK" ] || [ -z "$PORT" ]; then
    echo "Usage: ./benchmark-simple.sh <framework-name> <port>"
    echo "Example: ./benchmark-simple.sh nodejs-todo 3000"
    exit 1
fi

echo "Testing $FRAMEWORK on port $PORT"
echo "Make sure the server is already running!"
echo ""

# Wait for server to be ready
echo "Checking if server is running..."
if ! curl -s "http://localhost:$PORT/api/tasks" > /dev/null 2>&1; then
    echo "Error: Server not responding on http://localhost:$PORT"
    exit 1
fi
echo "✓ Server is running"
echo ""

# Warm up
echo "Warming up..."
for i in {1..10}; do
    curl -s "http://localhost:$PORT/api/tasks" > /dev/null
done
echo "✓ Warm up complete"
echo ""

# Test GET requests
echo "Testing GET /api/tasks (100 requests)..."
total_get=0
for i in {1..100}; do
    time=$(curl -s -w "%{time_total}" -o /dev/null "http://localhost:$PORT/api/tasks")
    total_get=$(echo "$total_get + $time" | bc)
done
avg_get=$(echo "scale=4; $total_get / 100" | bc)
echo "Average response time: ${avg_get}s"
echo ""

# Test POST requests
echo "Testing POST /api/tasks (100 requests)..."
total_post=0
for i in {1..100}; do
    time=$(curl -s -w "%{time_total}" -o /dev/null -X POST \
        -H "Content-Type: application/json" \
        -d '{"name":"Benchmark Task","description":"Performance test"}' \
        "http://localhost:$PORT/api/tasks")
    total_post=$(echo "$total_post + $time" | bc)
done
avg_post=$(echo "scale=4; $total_post / 100" | bc)
echo "Average response time: ${avg_post}s"
echo ""

# Concurrent requests test
echo "Testing concurrent requests (10 parallel, 100 total)..."
if command -v ab &> /dev/null; then
    ab -n 100 -c 10 -q "http://localhost:$PORT/api/tasks" | grep -E "Requests per second|Time per request|Failed requests"
else
    echo "Apache Bench not installed, skipping concurrent test"
fi
echo ""

echo "Benchmark complete!"
