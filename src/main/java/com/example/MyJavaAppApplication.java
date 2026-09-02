package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Value;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
@RestController
@RequestMapping("/api")
public class MyJavaAppApplication {

    private static int requestCount = 0;
    private static final LocalDateTime startTime = LocalDateTime.now();

    @Value("${app.version:2.0.0}")
    private String version;

    public static void main(String[] args) {
        SpringApplication.run(MyJavaAppApplication.class, args);
    }

    @GetMapping("/info")
    public Map<String, Object> getInfo() {
        requestCount++;
        Map<String, Object> response = new HashMap<>();
        response.put("time", LocalDateTime.now().format(DateTimeFormatter.ISO_INSTANT));
        response.put("container", System.getenv("HOSTNAME"));
        response.put("javaVersion", System.getProperty("java.version"));
        response.put("requests", requestCount);
        response.put("uptime", getUptime());
        response.put("version", version);
        response.put("runningInDocker", isRunningInDocker());
        return response;
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_INSTANT));
        return health;
    }

    @GetMapping("/version")
    public Map<String, String> getVersion() {
        Map<String, String> versionInfo = new HashMap<>();
        versionInfo.put("version", version);
        versionInfo.put("buildDate", "2026-09-01");
        return versionInfo;
    }

    private String getUptime() {
        LocalDateTime now = LocalDateTime.now();
        long seconds = java.time.Duration.between(startTime, now).getSeconds();
        long hours = seconds / 3600;
        long minutes = (seconds % 3600) / 60;
        long secs = seconds % 60;
        return String.format("%dh %dm %ds", hours, minutes, secs);
    }

    private boolean isRunningInDocker() {
        return System.getenv("HOSTNAME") != null || 
               new java.io.File("/.dockerenv").exists();
    }
}
