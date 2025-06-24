#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e

# 1. Install system tools
apt update -y
apt install -y git curl wget maven

# 2. Download & extract Java 19
cd /opt
wget https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2+7/OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz
mkdir -p /opt/java
tar -xzf OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz -C /opt/java

# 3. Symlink java & javac into /usr/local/bin
ln -sf /opt/java/jdk-19.0.2+7/bin/java   /usr/local/bin/java
ln -sf /opt/java/jdk-19.0.2+7/bin/javac  /usr/local/bin/javac

# 4. Verify Java
java -version

# 5. Clone your application
cd /opt
git clone https://github.com/KiranDigari/DevOps-project.git
cd DevOps-project

# 6. Build with Maven
mvn clean package -DskipTests

# 7. Run the Spring Boot JAR on port 80
sudo nohup java -jar target/*.jar --server.port=80 > /opt/app.log 2>&1 &

# 8. Auto-shutdown after 30 minutes
sudo shutdown -h +30
