#!/bin/bash

# Stop on error
set -e

# Update and install dependencies
sudo apt update -y
sudo apt install -y git curl fontconfig openjdk-19-jdk python3

# Print Java version
java -version

# Clone the repo
cd /opt
git clone ${repo_url}
cd assignment-1

# Run the app on port 80
sudo nohup python3 -m http.server 80 &

# Shutdown the instance after X minutes
sudo shutdown -h +${shutdown_after_minutes}

