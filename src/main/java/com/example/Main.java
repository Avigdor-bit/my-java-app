Step 1: Create the Java Project Structure

# Create standard Maven project structure
mkdir -p src/main/java/com/example
mkdir -p src/main/resources
mkdir -p src/test/java

# Create a simple Main.java file
cat > src/main/java/com/example/Main.java << 'EOF'
package com.example;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, Dockerized Java App!");
    }
}
