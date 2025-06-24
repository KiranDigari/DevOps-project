#!/bin/bash

apt update -y
apt install -y git curl wget


wget https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2+7/OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz
mkdir -p /opt/java
tar -xvzf OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz -C /opt/java
export JAVA_HOME=/opt/java/jdk-19.0.2+7
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java installation
java -version

# Clone your GitHub repo
cd /opt
git clone https://github.com/KiranDigari/DevOps-project.git
cd DevOps-project/assignment-1

# Placeholder for future .jar
# sudo nohup java -jar your-app.jar --server.port=80 &

# Auto-shutdown after X minutes
sudo shutdown -h +${shutdown_after_minutes)
