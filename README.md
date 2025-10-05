# Web Framework Benchmark

A comprehensive comparison of 6 modern web frameworks building the same todo list application.

## 🎯 Frameworks Tested

1. **Node.js + Express** (port 3000)
2. **Nest.js** (port 3001)
3. **Next.js** (port 3002)
4. **Spring Boot + Kotlin** (port 8080)
5. **Ktor** (port 8081)
6. **Rocket + Rust** (port 8082)

## 📁 Project Structure

```
framework-benchmark/
├── nodejs-todo/          # Node.js + Express implementation
├── nestjs-todo/          # Nest.js implementation
├── nextjs-todo/          # Next.js implementation
├── springboot-todo/      # Spring Boot + Kotlin implementation
├── ktor-todo/            # Ktor implementation
├── rocket-todo/          # Rocket + Rust implementation
├── benchmark.sh          # Automated benchmark script
├── benchmark-simple.sh   # Manual benchmark script
├── BENCHMARK_ANALYSIS.md # Complete analysis and results
└── README.md            # This file
```

## 🚀 Quick Start

### Node.js
```bash
cd nodejs-todo
npm install
npm start
# Open http://localhost:3000
```

### Nest.js
```bash
cd nestjs-todo
npm install
npm start
# Open http://localhost:3001
```

### Next.js
```bash
cd nextjs-todo
npm install
npm run dev    # or npm run build && npm start
# Open http://localhost:3002
```

### Spring Boot + Kotlin
```bash
cd springboot-todo
./gradlew bootRun
# Open http://localhost:8080
```

### Ktor
```bash
cd ktor-todo
./gradlew run
# Open http://localhost:8081
```

### Rocket + Rust
```bash
cd rocket-todo
cargo run --release
# Open http://localhost:8082
```

## 📊 Run Benchmarks

### Automated (all frameworks)
```bash
./benchmark.sh
```

### Manual (single framework)
```bash
# Start your server first, then:
./benchmark-simple.sh <folder-name> <port>

# Examples:
./benchmark-simple.sh nodejs-todo 3000
./benchmark-simple.sh nextjs-todo 3002
```

## 📋 Features

Each application implements:
- ✅ List all tasks (GET `/api/tasks`)
- ✅ Create task with name and description (POST `/api/tasks`)
- ✅ Delete task (DELETE `/api/tasks/:id`)
- ✅ Modern gradient UI design
- ✅ In-memory storage
- ✅ Fullstack (backend + frontend)

## 📈 Results Summary

See [BENCHMARK_ANALYSIS.md](BENCHMARK_ANALYSIS.md) for detailed analysis.

### Quick Rankings

| Category | Winner | Runner-up |
|----------|--------|-----------|
| **Performance** | Rocket | Node.js |
| **Developer Experience** | Next.js | Nest.js |
| **Enterprise Ready** | Spring Boot | Nest.js |
| **Fastest Startup** | Node.js | Rocket |
| **Lowest Memory** | Rocket | Node.js |

## 🛠️ Requirements

- **Node.js apps**: Node.js 18+ and npm
- **JVM apps**: JDK 17+ (Spring Boot, Ktor)
- **Rust app**: Rust toolchain (cargo)
- **Optional**: Apache Bench (ab) for load testing

## 📖 API Endpoints

All frameworks expose the same REST API:

```
GET    /api/tasks           - Get all tasks
POST   /api/tasks           - Create task
DELETE /api/tasks/:id       - Delete task

Body for POST: { "name": "string", "description": "string" }
```

## 🎨 UI

Each app includes a modern, responsive UI with:
- Purple gradient background
- Card-based task layout
- Smooth animations
- Mobile-friendly design

## 📝 License

MIT

## 🤝 Contributing

This is a benchmark project. Feel free to:
- Add more frameworks
- Improve existing implementations
- Submit benchmark results from your system
- Enhance the analysis

## 📚 Learn More

- [Benchmark Analysis](BENCHMARK_ANALYSIS.md) - Detailed performance analysis
- Framework documentation:
  - [Express](https://expressjs.com/)
  - [Nest.js](https://nestjs.com/)
  - [Next.js](https://nextjs.org/)
  - [Spring Boot](https://spring.io/projects/spring-boot)
  - [Ktor](https://ktor.io/)
  - [Rocket](https://rocket.rs/)
