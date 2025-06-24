#!/bin/bash

# Log all output to a file
exec > /var/log/setup-script.log 2>&1
set -e

# Install dependencies
apt update -y
apt install -y git curl wget maven

# Install Java 19
wget https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2+7/OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz
mkdir -p /opt/java
tar -xvzf OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz -C /opt/java

# Set Java environment variables for this script AND system-wide
export JAVA_HOME=/opt/java/jdk-19.0.2+7
export PATH=$JAVA_HOME/bin:$PATH

echo "export JAVA_HOME=/opt/java/jdk-19.0.2+7" >> /etc/profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile

# Verify Java
java -version

# Clone and run the app
cd /opt
git clone https://github.com/KiranDigari/DevOps-project.git
cd DevOps-project
mvn spring-boot:run > /opt/app.log 2>&1 &

# Auto shutdown
shutdown -h +10
