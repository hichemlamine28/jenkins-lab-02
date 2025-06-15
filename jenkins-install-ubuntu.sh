#!/bin/bash

sudo mkdir -p /etc/apt/keyrings
sudo apt --fix-broken install -y
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre-headless net-tools # openjdk-21-jre

java -version

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
