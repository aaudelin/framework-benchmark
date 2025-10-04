#!/bin/bash

# Benchmark script for testing all frameworks
# Tests: build time, startup time, response time, throughput

set -e

RESULTS_FILE="benchmark_results.txt"
echo "Framework Benchmark Results - $(date)" > $RESULTS_FILE
echo "================================================" >> $RESULTS_FILE
echo "" >> $RESULTS_FILE

# Function to measure time
measure_time() {
    local start=$(date +%s.%N)
    "$@"
    local end=$(date +%s.%N)
    local elapsed=$(echo "$end - $start" | bc)
    echo "$elapsed"
}

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local method=$2
    local data=$3

    if [ "$method" = "GET" ]; then
        curl -s -w "%{time_total}" -o /dev/null "$url"
    elif [ "$method" = "POST" ]; then
        curl -s -w "%{time_total}" -o /dev/null -X POST -H "Content-Type: application/json" -d "$data" "$url"
    elif [ "$method" = "DELETE" ]; then
        curl -s -w "%{time_total}" -o /dev/null -X DELETE "$url"
    fi
}

# Function to run Apache Bench if available
run_ab_test() {
    local url=$1
    local name=$2

    if command -v ab &> /dev/null; then
        echo "Running Apache Bench for $name..." >> $RESULTS_FILE
        ab -n 1000 -c 10 "$url" 2>&1 | grep -E "Requests per second|Time per request|Failed requests" >> $RESULTS_FILE
        echo "" >> $RESULTS_FILE
    fi
}

# Function to benchmark a framework
benchmark_framework() {
    local name=$1
    local port=$2
    local build_cmd=$3
    local run_cmd=$4
    local dir=$5

    echo "============================================" >> $RESULTS_FILE
    echo "Framework: $name" >> $RESULTS_FILE
    echo "============================================" >> $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    cd "$dir"

    # Measure build time
    echo "📦 Build Time:" >> $RESULTS_FILE
    build_time=$(measure_time bash -c "$build_cmd" 2>&1)
    echo "${build_time}s" >> $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    # Start server in background and measure startup time
    echo "🚀 Startup Time:" >> $RESULTS_FILE
    startup_start=$(date +%s.%N)
    eval "$run_cmd" > /dev/null 2>&1 &
    SERVER_PID=$!

    # Wait for server to be ready
    max_wait=60
    elapsed=0
    while ! curl -s "http://localhost:$port/api/tasks" > /dev/null 2>&1; do
        sleep 0.5
        elapsed=$((elapsed + 1))
        if [ $elapsed -gt $((max_wait * 2)) ]; then
            echo "Server failed to start" >> $RESULTS_FILE
            kill $SERVER_PID 2>/dev/null || true
            cd ..
            return 1
        fi
    done
    startup_end=$(date +%s.%N)
    startup_time=$(echo "$startup_end - $startup_start" | bc)
    echo "${startup_time}s" >> $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    # Warm up
    for i in {1..10}; do
        curl -s "http://localhost:$port/api/tasks" > /dev/null
    done

    # Test response times
    echo "⚡ Response Times (avg of 100 requests):" >> $RESULTS_FILE

    total_get=0
    for i in {1..100}; do
        time=$(test_endpoint "http://localhost:$port/api/tasks" "GET")
        total_get=$(echo "$total_get + $time" | bc)
    done
    avg_get=$(echo "scale=4; $total_get / 100" | bc)
    echo "GET /api/tasks: ${avg_get}s" >> $RESULTS_FILE

    total_post=0
    for i in {1..100}; do
        time=$(test_endpoint "http://localhost:$port/api/tasks" "POST" '{"name":"Test","description":"Benchmark"}')
        total_post=$(echo "$total_post + $time" | bc)
    done
    avg_post=$(echo "scale=4; $total_post / 100" | bc)
    echo "POST /api/tasks: ${avg_post}s" >> $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    # Apache Bench test (if available)
    run_ab_test "http://localhost:$port/api/tasks" "$name"

    # Memory usage (macOS specific)
    echo "💾 Memory Usage:" >> $RESULTS_FILE
    ps -o rss,vsz -p $SERVER_PID | tail -1 >> $RESULTS_FILE
    echo "" >> $RESULTS_FILE

    # Cleanup
    kill $SERVER_PID 2>/dev/null || true
    sleep 2

    cd ..
    echo "" >> $RESULTS_FILE
}

echo "Starting benchmark tests..."
echo ""

# Node.js
benchmark_framework "Node.js + Express" 3000 \
    "npm install --silent" \
    "node server.js" \
    "nodejs-todo"

# Nest.js
benchmark_framework "Nest.js" 3001 \
    "npm install --silent" \
    "npm start" \
    "nestjs-todo"

# Next.js
benchmark_framework "Next.js" 3002 \
    "npm install --silent && npm run build" \
    "npm start" \
    "nextjs-todo"

# Spring Boot
benchmark_framework "Spring Boot + Kotlin" 8080 \
    "./gradlew build -q" \
    "./gradlew bootRun -q" \
    "springboot-todo"

# Ktor
benchmark_framework "Ktor" 8081 \
    "./gradlew build -q" \
    "./gradlew run -q" \
    "ktor-todo"

# Rocket (if Rust is installed)
if command -v cargo &> /dev/null; then
    benchmark_framework "Rocket + Rust" 8082 \
        "cargo build --release" \
        "cargo run --release" \
        "rocket-todo"
else
    echo "Skipping Rocket (Rust not installed)" >> $RESULTS_FILE
fi

echo ""
echo "Benchmark complete! Results saved to $RESULTS_FILE"
cat $RESULTS_FILE
