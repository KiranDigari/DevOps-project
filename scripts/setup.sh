#!/bin/bash
set -xe # Exit immediately if a command exits with a non-zero status. Print commands before execution.

exec > /var/log/user-data.log 2>&1 # Redirect all script output to /var/log/user-data.log

# 1. Update apt and install git, curl, wget, maven
sudo apt update -y
sudo apt install -y git curl wget maven -y

# 2. Download & extract Java 19
cd /opt
JAVA_FILE="OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz"
JAVA_URL="https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/${JAVA_FILE}"
wget "${JAVA_URL}" -O /tmp/${JAVA_FILE}
mkdir -p /opt/java
tar -xzf /tmp/${JAVA_FILE} -C /opt/java --strip-components=1
rm /tmp/${JAVA_FILE}

export JAVA_HOME="/opt/java"
export PATH="$JAVA_HOME/bin:$PATH"

# 3. Symlink java & javac into /usr/local/bin
sudo ln -sf /opt/java/bin/java /usr/local/bin/java
sudo ln -sf /opt/java/bin/javac /usr/local/bin/javac

# 4. Verify Java
java -version

# 5. Clone your application
git clone https://github.com/KiranDigari/DevOps-project.git /opt/DevOps-project
cd /opt/DevOps-project

# 6. Build with Maven
mvn clean package -DskipTests

# 7. Run the Spring Boot JAR on port 80
sudo ufw disable || true # Disable UFW if active; '|| true' prevents script from failing if ufw isn't found
JAR_FILE=$(find target -name "*.jar" ! -name "*-sources.jar" ! -name "*-javadoc.jar" | head -n 1)
nohup java -jar "${JAR_FILE}" --server.port=80 > /opt/app.log 2>&1 &

# 8. Auto-shutdown after 30 minutes
sudo shutdown -h +30 &