#!/bin/bash

# Install yum-utils
sudo yum install -y yum-utils

# Add
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	
# Install Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io
 
# Start Docker Service
sudo systemctl start docker