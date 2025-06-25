#!/bin/bash
apt update -y
apt install -y git curl wget maven

# Install Java 19
cd /opt
wget https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz
tar -xvzf OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz
mv jdk-19.0.2+7 java-19
echo "export JAVA_HOME=/opt/java-19" >> /etc/profile
echo "export PATH=\$PATH:/opt/java-19/bin" >> /etc/profile
source /etc/profile

# Clone the GitHub repo passed from Terraform
cd /home/ubuntu
git clone "${repo_url}"
cd devops-project  # or adjust based on the repo name

# Build & run app (adjust path if needed)
mvn clean package
sudo nohup java -jar target/*.jar > app.log 2>&1 &

# Schedule shutdown
shutdown -h +${shutdown_after_minutes}
