#!/bin/bash

# Install yum-utils
sudo yum install -y yum-utils

# Add repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	
# Install Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Configure Docker to start on boot
sudo systemctl enable docker.service
 
# Start Docker Service
sudo systemctl start docker