# Docker Java Web Server  on a {Linux Distro Ubuntu 26.04 LTS }
A lightweight Java web server running inside Docker, built with `com.sun.net.httpserver`. This application provides a simple web interface with statistics, health checks, and version information — perfect for learning Docker + Java or testing container deployments.

---

## 🚀 Features

- **Simple HTTP server** using Java's built-in `HttpServer`
- **Multiple endpoints**: home page, stats, health, version
- **Request counter** (atomic, thread-safe)
- **Uptime tracking** with human-readable formatting
- **Container-aware** – displays container ID from hostname
- **Thread-pooled** for handling concurrent requests
- **Graceful shutdown** via JVM shutdown hook
- **Clean HTML/CSS** styled pages

---

## 📦 Endpoints

| Endpoint     | Description                                  |
|--------------|----------------------------------------------|
| `/`          | Home page with app info, uptime, request count |
| `/stats`     | Detailed server statistics                   |
| `/health`    | Simple health check – returns `OK`           |
| `/version`   | JSON response with app name, version, Java version |

---

## 🐳 Docker Quick Start

### Build the image

Create a `Dockerfile` in the same directory as `Main.java`:

```dockerfile
FROM openjdk:17-slim

WORKDIR /app

COPY Main.java .

RUN javac Main.java

EXPOSE 8080

CMD ["java", "Main"]
```

Then build and run:

```bash
docker build -t java-web-server .
docker run -d -p 8080:8080 --name my-java-app java-web-server
```

### Or use the prebuilt image (if available)

```bash
docker pull yourusername/java-web-server:latest
docker run -d -p 8080:8080 yourusername/java-web-server
```

---

## 🔧 Local Development (without Docker)

### Prerequisites

- Java 8 or higher (tested with Java 17+)

### Compile & Run

```bash
javac Main.java
java Main
```

Then open `http://localhost:8080` in your browser.

---

## 🧪 Testing

You can test endpoints using `curl`:

```bash
# Home page
curl http://localhost:8080/

# Health check
curl http://localhost:8080/health

# Stats page
curl http://localhost:8080/stats

# Version JSON
curl http://localhost:8080/version
```

---

## 📊 Sample Output

**Home page (`/`)**:
```
✅ Docker Java App Running! [v2.0.0]
⏰ Time: 2026-09-02T12:34:56Z
🐳 Container: abc123def456
☕ Java Version: 17.0.8
📊 Requests: 42
🆙 Uptime: 1h 23m 45s
```

**Version endpoint (`/version`)**:
```json
{
  "app": "Docker Java App",
  "version": "2.0.0",
  "java": "17.0.8"
}
```

---

## 🛠️ Customization

### Change version or app name

Edit the constants at the top of `Main.java`:

```java
private static final String VERSION = "2.0.0";
private static final String APP_NAME = "Docker Java App";
```

### Change port

Modify the port in `HttpServer.create()`:

```java
HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
```

---

## 🏗️ Architecture

- **Main.java**: Single-file application
- **HttpServer**: Built-in Java HTTP server (no external dependencies)
- **AtomicInteger**: Thread-safe request counter
- **CachedThreadPool**: Handles concurrent connections efficiently
- **Shutdown hook**: Ensures clean shutdown on container stop

---

## 📁 Project Structure

```
.
├── Main.java          # Single source file – the entire app
└── README.md          # This file
```

---

## 📄 License

This project is open-source and available under the MIT License.

---

## ✨ Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 🐛 Issues

If you encounter any issues, please open an issue on the GitHub repository with:
- Docker version
- Java version
- Steps to reproduce
- Full error output (if any)

---

**Happy coding! 🚀**

