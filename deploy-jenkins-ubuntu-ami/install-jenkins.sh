#!/bin/bash

sudo apt-get update -y
sudo apt-get install dialog apt-utils -y
sudo apt-get install fontconfig openjdk-17-jre -y
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl enable jenkins
